class AddRememberTokenToAdmins < ActiveRecord::Migration[7.2]
  def change
    add_column :admins, :remember_token, :string
    add_index :admins, :remember_token, unique: true
  end
end
