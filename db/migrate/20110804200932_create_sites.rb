class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.integer  :user_id, :null => false, :on_delete => :cascade, :on_update => :cascade
      t.string   :key, :null => false, :index => :unique
      t.string   :name, :null => false
      t.string   :url
      t.datetime :created_at, :null => false
      t.datetime :updated_at, :null => false
      t.integer  :moderation_method, :null => false, :default => 0
      t.string   :akismet_key
    end
  end

  def self.down
    drop_table :sites
  end
end
