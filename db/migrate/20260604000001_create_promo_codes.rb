class CreatePromoCodes < ActiveRecord::Migration[8.1]
  def change
    create_table :promo_codes do |t|
      t.string :code, null: false
      t.integer :discount, null: false, default: 0
      t.boolean :active, default: true
      t.datetime :expires_at
      t.integer :max_uses
      t.integer :uses_count, default: 0
      t.timestamps
    end

    add_index :promo_codes, :code, unique: true
  end
end