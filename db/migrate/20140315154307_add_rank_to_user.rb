class AddRankToUser < ActiveRecord::Migration
  def change
    add_column :users, :current_rank, :integer
    add_column :users, :max_rank, :integer
  end
end
