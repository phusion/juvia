class AddUserNotificationEmailToSites < ActiveRecord::Migration
  def change
    add_column :sites, :user_notification_email, :string, :default => ""
  end
end
