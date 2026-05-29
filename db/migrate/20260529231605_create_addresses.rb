class CreateAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :full_name, null: false
      t.string :phone, null: false
      t.string :city, null: false
      t.string :street, null: false
      t.string :house, null: false
      t.string :apartment
      t.string :zip_code
      t.boolean :is_default, default: false, null: false
      t.timestamps
    end
  end
end
