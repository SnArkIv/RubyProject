class UpdateProductsForMarket < ActiveRecord::Migration[8.1]
  def up
    # Remove old fields
    remove_column :products, :compare_at_price, if_exists: true
    remove_column :products, :category, if_exists: true

    # Add new fields
    add_column :products, :sku, :string
    add_index :products, :sku, unique: true
    add_column :products, :discount, :integer, default: 0, null: false
    add_column :products, :status, :integer, default: 0, null: false
    add_column :products, :average_rating, :decimal, precision: 3, scale: 2, default: 0, null: false
    add_column :products, :in_stock, :boolean, default: true, null: false
    add_reference :products, :category, foreign_key: true
    add_reference :products, :brand, foreign_key: true
  end

  def down
    remove_reference :products, :category, foreign_key: true, if_exists: true
    remove_reference :products, :brand, foreign_key: true, if_exists: true
    remove_column :products, :in_stock, if_exists: true
    remove_column :products, :average_rating, if_exists: true
    remove_column :products, :status, if_exists: true
    remove_column :products, :discount, if_exists: true
    remove_index :products, :sku, if_exists: true
    remove_column :products, :sku, if_exists: true
    add_column :products, :category, :string, null: false
    add_column :products, :compare_at_price, :decimal, precision: 10, scale: 2
  end
end
