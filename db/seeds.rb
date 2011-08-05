# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

site = Site.create!(:key => 'testkey', :name => 'Test Site')
topic = site.topics.create!(:key => 'testtopic', :title => 'Test Topic', :url => 'http://test')
topic.comments.create!(:content => 'hello world')