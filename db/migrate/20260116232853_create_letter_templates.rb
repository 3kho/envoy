class CreateLetterTemplates < ActiveRecord::Migration[7.2]
  def change
    create_table :letter_templates, id: :uuid do |t|
      t.string :name, null: false
      t.text :body, null: false
      t.string :signatory_name, null: false
      t.string :signatory_title, null: false
      t.references :event, null: true, foreign_key: true, type: :uuid
      t.boolean :is_default, default: false, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :letter_templates, :is_default
    add_index :letter_templates, [:event_id, :active]
  end
end
