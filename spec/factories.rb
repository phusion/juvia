FactoryGirl.define do
  factory :admin, :class => User do
    email 'admin@admin.com'
    password 123456
    password_confirmation 123456
    is_admin true
  end
  
  factory :kotori, :class => User do
    email 'kotori@kotori.jp'
    password 123456
    password_confirmation 123456
  end
  
  factory :hatsuneshima, :class => Site do
    name 'Hatsuneshima'
    key 'hatsuneshima'
  end
  
  factory :topic do
    key 'topic'
    title 'my topic'
    url 'http://www.google.com'
  end
  
  factory :comment do
    content 'a comment'
    author_ip '127.0.0.1'
    author_user_agent 'Firefox'
    referer 'http://www.google.com/'
  end
end

module FactoryHelpers
  def kotori(attrs = {})
    @kotori ||= FactoryGirl.create(:kotori, attrs)
  end
  
  def hatsuneshima(attrs = {})
    @hatsuneshima ||= FactoryGirl.create(:hatsuneshima,
      { :user => kotori }.merge(attrs))
  end
end

