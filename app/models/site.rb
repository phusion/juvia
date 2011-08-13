class Site < ActiveRecord::Base
  belongs_to :user, :inverse_of => :sites
  has_many :topics, :inverse_of=> :site
  
  acts_as_enum :moderation_method, [:none, :akismet, :manual]
  
  default_value_for(:key) { ActiveSupport::SecureRandom.hex(20).to_i(16).to_s(36) }
end
