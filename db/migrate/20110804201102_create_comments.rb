class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer  :topic_id, :null => false, :on_update => :cascade, :on_delete => :cascade
      t.boolean  :passed_moderation, :null => false
      t.string   :author_name
      t.string   :author_email
      t.text     :content, :null => false
      t.datetime :created_at, :null => false
    end
  end

  def self.down
    drop_table :comments
  end
end
