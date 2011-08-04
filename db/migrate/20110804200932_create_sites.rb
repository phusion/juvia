class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string   :name, :null => false
      t.string   :key, :null => false
      t.datetime :created_at, :null => false
      t.datetime :updated_at, :null => false
      t.boolean  :moderated, :null => false, :default => true
    end
  end

  def self.down
    drop_table :sites
  end
end
