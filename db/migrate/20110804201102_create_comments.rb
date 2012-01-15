class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer  :topic_id, :null => false, :on_update => :cascade, :on_delete => :cascade
      t.integer  :moderation_status, :null => false, :default => 0
      t.string   :author_name
      t.string   :author_email
      t.string   :author_ip, :null => false
      t.string   :author_user_agent
      t.string   :referer
      t.text     :content, :null => false
      t.datetime :created_at, :null => false
    end
  end

  def self.down
    drop_table :comments
  end
end
