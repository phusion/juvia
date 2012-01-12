# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

if Rails.env.development?
  user = User.create!({
      :email => 'a@a.com',
      :password => '123456',
      :password_confirmation => '123456',
      :admin => true
    }, :as => :admin)
  site = user.sites.create!({
      :key => 'testkey',
      :name => 'Test Site',
      :url => 'http://test',
      :user => user
    }, :as => :admin)
  site.update_attribute(:key, 'testkey')
  topic = site.topics.create!(:key => 'testtopic', :title => 'Test Topic', :url => 'http://test/testtopic')
  topic.comments.create!(:content => 'hello world',
    :author_ip => '127.0.0.1',
    :author_user_agent => 'Firefox',
    :referer => 'http://www.google.com')
else
  User.create!({
    :email => 'admin@localhost',
    :password => 'admin',
    :password_confirmation => 'admin',
    :admin => true
  }, :as => :admin)
end
