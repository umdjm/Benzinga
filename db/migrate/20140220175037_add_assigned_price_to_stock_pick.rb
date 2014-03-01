class AddAssignedPriceToStockPick < ActiveRecord::Migration
  def change
    add_column :stock_picks, :assigned_price, :decimal
  end
end
