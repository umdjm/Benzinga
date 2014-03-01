class CreateStockResults < ActiveRecord::Migration
  def change
    create_table :stock_results do |t|
      t.string :stock
      t.date :result_date
      t.string :direction

      t.timestamps
    end
  end
end
