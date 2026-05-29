class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, default: 0, null: false
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.text :shipping_address
      t.timestamps
    end
  end
end
