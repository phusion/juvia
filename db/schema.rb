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

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean  "admin",                                 :default => false, :null => false
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.index ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
    t.index ["email"], :name => "index_users_on_email", :unique => true
  end

  create_table "sites", :force => true do |t|
    t.integer  "user_id",                          :null => false
    t.string   "key",                              :null => false
    t.string   "name",                             :null => false
    t.string   "url"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "moderation_method", :default => 0, :null => false
    t.string   "akismet_key"
    t.index ["key"], :name => "index_sites_on_key", :unique => true
    t.index ["user_id"], :name => "index_sites_on_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :cascade, :on_delete => :cascade
  end

  create_table "topics", :force => true do |t|
    t.integer  "site_id",        :null => false
    t.string   "key",            :null => false
    t.string   "title",          :null => false
    t.string   "url",            :null => false
    t.datetime "created_at",     :null => false
    t.datetime "last_posted_at"
    t.index ["site_id", "key"], :name => "index_topics_on_site_id_and_key", :unique => true
    t.index ["site_id"], :name => "index_topics_on_site_id"
    t.foreign_key ["site_id"], "sites", ["id"], :on_update => :cascade, :on_delete => :cascade
  end

  create_table "comments", :force => true do |t|
    t.integer  "topic_id",                         :null => false
    t.integer  "moderation_status", :default => 0, :null => false
    t.string   "author_name"
    t.string   "author_email"
    t.string   "author_ip",                        :null => false
    t.string   "author_user_agent"
    t.string   "referer"
    t.text     "content",                          :null => false
    t.datetime "created_at",                       :null => false
    t.index ["topic_id"], :name => "index_comments_on_topic_id"
    t.foreign_key ["topic_id"], "topics", ["id"], :on_update => :cascade, :on_delete => :cascade
  end

end
