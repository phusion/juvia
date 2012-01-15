require 'digest/md5'
require 'net/http'
require 'cgi'

class Comment < ActiveRecord::Base
  class AkismetError < StandardError
  end

  belongs_to :topic, :inverse_of => :comments
  
  acts_as_enum :moderation_status, [:ok, :unchecked, :spam]
  
  scope :visible, where(:moderation_status => moderation_status(:ok))
  scope :requiring_moderation, where("moderation_status != #{moderation_status(:ok)}")
  
  validates_presence_of :content
  validates_presence_of :author_ip
  
  before_validation :nullify_blank_fields
  before_create :set_moderation_status
  after_create :update_topic_timestamp
  after_create :notify_moderators
  
  def site
    topic.site
  end

  def author_email_md5
    if author_email
      Digest::MD5.hexdigest(author_email.downcase)
    else
      nil
    end
  end
  
  def spam?
    response = call_akismet('comment-check', akismet_params)
    if response.body == 'invalid'
      if response['X-akismet-debug-help']
        message = "Akismet server error: " << response['X-akismet-debug-help']
      else
        message = "Unknown Akismet server error, maybe your API key is wrong"
      end
      raise AkismetError, message
    elsif response.body == 'true'
      true
    elsif response.body == 'false'
      false
    else
      raise AkismetError, "Akismet server error: #{response.body}"
    end
  end
  
  def report_ham
    call_akismet('submit-ham', akismet_params)
  end
  
  def report_spam
    call_akismet('submit-spam', akismet_params)
  end

private
  AKISMET_HEADERS = {
    'User-Agent' => "Juvia | Rails/#{Rails.version}",
    'Content-Type' => 'application/x-www-form-urlencoded'
  }
  
  def nullify_blank_fields
    self.author_name  = nil if author_name.blank?
    self.author_email = nil if author_email.blank?
    self.author_user_agent = nil if author_user_agent.blank?
    self.referer = nil if referer.blank?
  end
  
  def akismet_params
    raise AkismetError, "Site URL required for Akismet check" if topic.site.url.blank?
    params = {
      :blog => topic.site.url,
      :user_ip => author_ip,
      :user_agent => author_user_agent,
      :referrer => referer,
      :comment_content => content,
      :comment_type => 'comment'
    }
    params[:comment_author] = author_name if author_name.present?
    params[:comment_author_email] = author_email if author_email.present?
    params
  end
  
  def call_akismet(function_name, params)
    raise AkismetError, "Akismet key required" if topic.site.akismet_key.blank?
    uri = URI.parse("http://#{topic.site.akismet_key}.rest.akismet.com/1.1/#{function_name}")
    post_data = params.map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join('&')
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.post(uri.path, post_data, AKISMET_HEADERS)
    end
    if response.code != "200"
      raise AkismetError, "Akismet internal error #{response.code}"
    else
      response
    end
  end
  
  def set_moderation_status
    case topic.site.moderation_method
    when :akismet
      self.moderation_status = spam? ? :spam : :ok
    when :manual
      self.moderation_status = :unchecked
    else
      self.moderation_status = :ok
    end
  end

  def update_topic_timestamp
    if topic
      topic.update_attribute(:last_posted_at, Time.now)
    end
  end

  def notify_moderators
    Mailer.comment_posted(self).deliver
  end
end
