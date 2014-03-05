class AddCountsToUser < ActiveRecord::Migration
  def change
    add_column :users, :correct_count, :integer
    add_column :users, :incorrect_count, :integer
  end
end
