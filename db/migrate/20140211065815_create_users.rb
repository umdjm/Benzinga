class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.integer :current_streak
      t.integer :max_streak

      t.timestamps
    end
  end
end
