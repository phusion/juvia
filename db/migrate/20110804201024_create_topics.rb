class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.integer  :site_id, :null => false
      t.string   :identifier, :null => false
      t.string   :title, :null => false
      t.string   :origin_url, :null => false
      t.datetime :created_at, :null => false
    end
    add_index :topics, [:site_id, :identifier], :unique => true
  end

  def self.down
    drop_table :topics
  end
end
