# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110804201102) do

  create_table "sites", :force => true do |t|
    t.string   "name",                         :null => false
    t.string   "key",                          :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "moderated",  :default => true, :null => false
  end

  create_table "topics", :force => true do |t|
    t.integer  "site_id",    :null => false
    t.string   "identifier", :null => false
    t.string   "title",      :null => false
    t.string   "origin_url", :null => false
    t.datetime "created_at", :null => false
    t.index ["site_id", "identifier"], :name => "index_topics_on_site_id_and_identifier", :unique => true
    t.index ["site_id"], :name => "index_topics_on_site_id"
    t.foreign_key ["site_id"], "sites", ["id"], :on_update => :no_action, :on_delete => :no_action
  end

  create_table "comments", :force => true do |t|
    t.integer  "topic_id",          :null => false
    t.boolean  "passed_moderation", :null => false
    t.string   "author_name"
    t.string   "author_email"
    t.text     "content",           :null => false
    t.datetime "created_at",        :null => false
    t.index ["topic_id"], :name => "index_comments_on_topic_id"
    t.foreign_key ["topic_id"], "topics", ["id"], :on_update => :cascade, :on_delete => :cascade
  end

end
