class CreateActivityLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :activity_logs, id: :uuid do |t|
      t.string :trackable_type, null: false
      t.uuid :trackable_id, null: false
      t.references :admin, null: true, foreign_key: true, type: :uuid
      t.string :action, null: false
      t.jsonb :metadata, default: {}, null: false
      t.string :ip_address
      t.string :user_agent

      t.datetime :created_at, null: false
    end

    add_index :activity_logs, [:trackable_type, :trackable_id]
    add_index :activity_logs, :action
    add_index :activity_logs, :created_at
  end
end
