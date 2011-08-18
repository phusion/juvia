class Site < ActiveRecord::Base
  belongs_to :user, :inverse_of => :sites
  has_many :topics, :inverse_of=> :site
  has_many :comments, :through => :topics
  
  acts_as_enum :moderation_method, [:none, :akismet, :manual]
  
  validates_presence_of :name
  validates_presence_of :key
  validates_presence_of :moderation_method
  
  attr_accessible :name, :url, :moderation_method, :akismet_key
  attr_accessible :user, :user_id, :name, :key, :url,
    :moderation_method, :akismet_key, :as => :admin
  
  default_value_for(:key) { SecureRandom.hex(20).to_i(16).to_s(36) }
end
