class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.integer  :site_id, :null => false, :on_update => :cascade, :on_delete => :cascade
      t.string   :key, :null => false
      t.string   :title, :null => false
      t.string   :url, :null => false
      t.datetime :created_at, :null => false
      t.datetime :last_posted_at
    end
    add_index :topics, [:site_id, :key], :unique => true
  end

  def self.down
    drop_table :topics
  end
end
