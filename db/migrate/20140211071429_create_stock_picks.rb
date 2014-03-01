class CreateStockPicks < ActiveRecord::Migration
  def change
    create_table :stock_picks do |t|
      t.boolean :success
      t.string :prediction

      t.belongs_to :stock_result
      t.belongs_to :user

      t.timestamps
    end
  end
end
