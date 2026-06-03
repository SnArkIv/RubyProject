class AddStockBySizeToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :stock_by_size, :jsonb, default: {}
  end
end