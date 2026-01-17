class CreateVisaLetterApplications < ActiveRecord::Migration[7.2]
  def change
    create_table :visa_letter_applications, id: :uuid do |t|
      t.references :participant, null: false, foreign_key: true, type: :uuid
      t.references :event, null: false, foreign_key: true, type: :uuid
      t.references :reviewed_by, null: true, foreign_key: { to_table: :admins }, type: :uuid
      t.string :status, null: false, default: "pending_verification"
      t.text :admin_notes
      t.text :rejection_reason
      t.datetime :submitted_at
      t.datetime :reviewed_at
      t.datetime :letter_generated_at
      t.datetime :letter_sent_at
      t.string :reference_number, null: false

      t.timestamps
    end

    add_index :visa_letter_applications, :status
    add_index :visa_letter_applications, :reference_number, unique: true
    add_index :visa_letter_applications, [:participant_id, :event_id], unique: true
    add_index :visa_letter_applications, :submitted_at
  end
end
