class CreateCarts < ActiveRecord::Migration[8.1]
  def change
    create_table :carts do |t|
      t.string :session_token
      t.references :user, foreign_key: true
      t.timestamps
    end

    add_index :carts, :session_token, unique: true
  end
end
