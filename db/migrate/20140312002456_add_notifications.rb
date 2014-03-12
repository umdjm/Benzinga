
class AddNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :template
      t.datetime :notification_date
      t.references :user
      t.string :status

      t.timestamps
    end
    add_index :notifications, :user_id
  end
end