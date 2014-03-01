class AddPricesToResult < ActiveRecord::Migration
  def change
    add_column :stock_results, :closing_price, :decimal
    add_column :stock_results, :opening_price, :decimal
  end
end
