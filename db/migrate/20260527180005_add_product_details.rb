class AddProductDetails < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :material, :string
    add_column :products, :color, :string
    add_column :products, :brand, :string
    add_column :products, :care_instructions, :text
  end
end
