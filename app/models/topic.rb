class Topic < ActiveRecord::Base

  # Check desired sort order
  if Rails.application.config.comment_order == 'earliest-first'
    orderAbbrev = 'ASC'
  else
    orderAbbrev = 'DESC'
  end

  belongs_to :site, :inverse_of => :topics
  has_many :comments, :order => "created_at #{orderAbbrev}", :inverse_of => :topic

  validates_presence_of :key
  validates_presence_of :title
  validates_presence_of :site_id
  validates_presence_of :url

  def self.lookup(site_key, topic_key)
    topic = find_by_site_key_and_topic_key(site_key, topic_key)
    if topic
      topic
    else
      site = Site.find_by_key(site_key)
      if site
        Topic.new(:key => topic_key, :site => site)
      else
        nil
      end
    end
  end

  def self.lookup_or_create(site_key, topic_key, topic_title, topic_url)
    topic = find_by_site_key_and_topic_key(site_key, topic_key)
    if topic
      topic
    else
      site = Site.find_by_key(site_key)
      if site
        site.topics.create!(
          :key => topic_key,
          :title => topic_title,
          :url => topic_url)
      else
        nil
      end
    end
  end

  def self.alt_key(topic_key)
    topic_key.match(/\/$/) ? topic_key.chop : "#{topic_key}/"
  end

private
  def self.find_by_site_key_and_topic_key(site_key, topic_key)
    Topic.
      where('sites.key = ? AND topics.key = ?', site_key, topic_key).
      joins(:site).
      first ||
    Topic.
      where('sites.key = ? AND topics.key = ?', site_key, alt_key(topic_key)).
      joins(:site).
      first
  end
end
