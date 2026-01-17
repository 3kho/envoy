# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_01_17_045054) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activity_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "trackable_type", null: false
    t.uuid "trackable_id", null: false
    t.uuid "admin_id"
    t.string "action", null: false
    t.jsonb "metadata", default: {}, null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.index ["action"], name: "index_activity_logs_on_action"
    t.index ["admin_id"], name: "index_activity_logs_on_admin_id"
    t.index ["created_at"], name: "index_activity_logs_on_created_at"
    t.index ["trackable_type", "trackable_id"], name: "index_activity_logs_on_trackable_type_and_trackable_id"
  end

  create_table "admins", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", limit: 100, null: false
    t.string "last_name", limit: 100, null: false
    t.boolean "super_admin", default: false, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_admins_on_unlock_token", unique: true
  end

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.string "venue_name", null: false
    t.string "venue_address", null: false
    t.string "city", null: false
    t.string "country", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "application_deadline"
    t.string "contact_email", null: false
    t.boolean "active", default: true, null: false
    t.boolean "applications_open", default: true, null: false
    t.uuid "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_events_on_active"
    t.index ["admin_id"], name: "index_events_on_admin_id"
    t.index ["applications_open"], name: "index_events_on_applications_open"
    t.index ["slug"], name: "index_events_on_slug", unique: true
    t.index ["start_date"], name: "index_events_on_start_date"
  end

  create_table "letter_templates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "body", null: false
    t.string "signatory_name", null: false
    t.string "signatory_title", null: false
    t.uuid "event_id"
    t.boolean "is_default", default: false, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "active"], name: "index_letter_templates_on_event_id_and_active"
    t.index ["event_id"], name: "index_letter_templates_on_event_id"
    t.index ["is_default"], name: "index_letter_templates_on_is_default"
  end

  create_table "participants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "full_name", null: false
    t.date "date_of_birth", null: false
    t.string "country_of_birth", null: false
    t.string "phone_number", null: false
    t.text "full_street_address", null: false
    t.string "verification_code"
    t.datetime "verification_code_sent_at"
    t.datetime "email_verified_at"
    t.integer "verification_attempts", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "place_of_birth"
    t.index ["email"], name: "index_participants_on_email"
    t.index ["verification_code"], name: "index_participants_on_verification_code"
  end

  create_table "visa_letter_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "participant_id", null: false
    t.uuid "event_id", null: false
    t.uuid "reviewed_by_id"
    t.string "status", default: "pending_verification", null: false
    t.text "admin_notes"
    t.text "rejection_reason"
    t.datetime "submitted_at"
    t.datetime "reviewed_at"
    t.datetime "letter_generated_at"
    t.datetime "letter_sent_at"
    t.string "reference_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "verification_code"
    t.index ["event_id"], name: "index_visa_letter_applications_on_event_id"
    t.index ["participant_id", "event_id"], name: "index_visa_letter_applications_on_participant_id_and_event_id", unique: true
    t.index ["participant_id"], name: "index_visa_letter_applications_on_participant_id"
    t.index ["reference_number"], name: "index_visa_letter_applications_on_reference_number", unique: true
    t.index ["reviewed_by_id"], name: "index_visa_letter_applications_on_reviewed_by_id"
    t.index ["status"], name: "index_visa_letter_applications_on_status"
    t.index ["submitted_at"], name: "index_visa_letter_applications_on_submitted_at"
    t.index ["verification_code"], name: "index_visa_letter_applications_on_verification_code", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activity_logs", "admins"
  add_foreign_key "events", "admins"
  add_foreign_key "letter_templates", "events"
  add_foreign_key "visa_letter_applications", "admins", column: "reviewed_by_id"
  add_foreign_key "visa_letter_applications", "events"
  add_foreign_key "visa_letter_applications", "participants"
end
