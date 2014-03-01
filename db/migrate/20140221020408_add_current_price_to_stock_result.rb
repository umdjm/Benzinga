class AddCurrentPriceToStockResult < ActiveRecord::Migration
  def change
    add_column :stock_results, :current_price, :decimal
  end
end
