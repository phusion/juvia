class Topic < ActiveRecord::Base
  belongs_to :site
  has_many :comments, :order => 'created_at DESC'
  
  def self.lookup(site_key, topic_key)
    Topic.
      where('sites.key = ? AND topics.key = ?', site_key, topic_key).
      joins(:site).
      first
  end
  
  def self.lookup_or_create(site_key, topic_key, topic_title, topic_url)
    topic = lookup(site_key, topic_key)
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
end
