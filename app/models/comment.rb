require 'digest/md5'
require 'net/http'
require 'cgi'

class Comment < ActiveRecord::Base
  belongs_to :topic, :inverse_of => :comments
  
  acts_as_enum :moderation_status, [:ok, :spam, :unchecked]
  
  scope :visible, where(:moderation_status => moderation_status(:ok))
  
  validates_presence_of :content
  validates_presence_of :author_ip
  validates_presence_of :author_user_agent
  validates_presence_of :referrer
  
  before_validation :nullify_blank_fields
  before_create :set_moderation_status
  
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
      message = "Akismet error"
      if response.headers['X-akismet-debug-help']
        message << ": " << response.headers['X-akismet-debug-help']
      end
      raise(message)
    elsif response.body == 'true'
      true
    elsif response.body == 'false'
      false
    else
      raise "Akismet error: #{response.body}"
    end
  end
  
  def ham!
    call_akismet('submit-ham', akismet_params)
  end
  
  def spam!
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
  end
  
  def akismet_params
    raise "Site URL required for Akismet check" if topic.site.url.blank?
    params = {
      :blog => topic.site.url,
      :user_ip => author_ip,
      :user_agent => author_user_agent,
      :referrer => referrer,
      :comment_content => content,
      :comment_type => 'comment'
    }
    params[:comment_author] = author_name if author_name.present?
    params[:comment_author_email] = author_email if author_email.present?
    params
  end
  
  def call_akismet(function_name, params)
    raise "Akismet key required" if topic.site.akismet_key.blank?
    uri = URI.parse("http://#{topic.site.akismet_key}.rest.akismet.com/1.1/#{function_name}")
    post_data = params.map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join('&')
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.post(uri.path, post_data, AKISMET_HEADERS)
    end
    if response.code != "200"
      raise "Akismet internal error #{response.code}"
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
end
