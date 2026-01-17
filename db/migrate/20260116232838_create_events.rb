class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.string :venue_name, null: false
      t.string :venue_address, null: false
      t.string :city, null: false
      t.string :country, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.datetime :application_deadline
      t.string :contact_email, null: false
      t.boolean :active, default: true, null: false
      t.boolean :applications_open, default: true, null: false
      t.references :admin, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :events, :slug, unique: true
    add_index :events, :start_date
    add_index :events, :active
    add_index :events, :applications_open
  end
end
