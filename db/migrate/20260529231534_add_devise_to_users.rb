class AddDeviseToUsers < ActiveRecord::Migration[8.1]
  def up
    change_table :users, bulk: true do |t|
      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Role
      t.integer :role, default: 0, null: false
    end

    add_index :users, :reset_password_token, unique: true

    # Remove old password_digest
    remove_column :users, :password_digest, if_exists: true

    # Migrate existing users: set a default encrypted_password so they can use password reset
    User.reset_column_information
    User.find_each do |user|
      # Existing users will need to use "Forgot password" to set a new password
      # We set a random password here to satisfy NOT NULL
      user.update_column(:encrypted_password, Devise.bcrypt(User, SecureRandom.hex(20)))
    end
  end

  def down
    change_table :users, bulk: true do |t|
      t.string :password_digest
      t.remove :encrypted_password
      t.remove :reset_password_token
      t.remove :reset_password_sent_at
      t.remove :remember_created_at
      t.remove :role
    end
  end
end
