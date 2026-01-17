class CreateParticipants < ActiveRecord::Migration[7.2]
  def change
    create_table :participants, id: :uuid do |t|
      t.string :email, null: false
      t.string :full_name, null: false
      t.date :date_of_birth, null: false
      t.string :country_of_birth, null: false
      t.string :phone_number, null: false
      t.text :full_street_address, null: false
      t.string :verification_code
      t.datetime :verification_code_sent_at
      t.datetime :email_verified_at
      t.integer :verification_attempts, default: 0, null: false

      t.timestamps
    end

    add_index :participants, :email
    add_index :participants, :verification_code
  end
end
