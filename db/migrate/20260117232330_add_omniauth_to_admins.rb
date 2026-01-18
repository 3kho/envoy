class AddOmniauthToAdmins < ActiveRecord::Migration[7.2]
  def change
    add_column :admins, :provider, :string
    add_column :admins, :uid, :string

    add_index :admins, [ :provider, :uid ], unique: true

    remove_column :admins, :encrypted_password, :string
    remove_column :admins, :reset_password_token, :string
    remove_column :admins, :reset_password_sent_at, :datetime
  end
end
