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

ActiveRecord::Schema[8.1].define(version: 2026_05_07_120048) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "contracts", force: :cascade do |t|
    t.integer "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "end_date"
    t.integer "freelancer_id", null: false
    t.bigint "job_id", null: false
    t.bigint "proposal_id", null: false
    t.datetime "start_date"
    t.string "status", default: "active"
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_contracts_on_client_id"
    t.index ["freelancer_id"], name: "index_contracts_on_freelancer_id"
    t.index ["job_id"], name: "index_contracts_on_job_id"
    t.index ["proposal_id"], name: "index_contracts_on_proposal_id"
    t.index ["status"], name: "index_contracts_on_status"
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.bigint "freelancer_id", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id", "freelancer_id"], name: "index_conversations_on_client_id_and_freelancer_id", unique: true
    t.index ["client_id"], name: "index_conversations_on_client_id"
    t.index ["freelancer_id"], name: "index_conversations_on_freelancer_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.decimal "budget"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "deadline"
    t.text "description"
    t.string "status", default: "open"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body", null: false
    t.integer "conversation_id", null: false
    t.datetime "created_at", null: false
    t.boolean "read", default: false
    t.integer "sender_id", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "job_id", null: false
    t.datetime "payment_date"
    t.string "status", default: "pending"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["job_id"], name: "index_payments_on_job_id"
    t.index ["status"], name: "index_payments_on_status"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "proposals", force: :cascade do |t|
    t.text "cover_letter"
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["job_id", "user_id"], name: "index_proposals_on_job_id_and_user_id", unique: true
    t.index ["job_id"], name: "index_proposals_on_job_id"
    t.index ["status"], name: "index_proposals_on_status"
    t.index ["user_id"], name: "index_proposals_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "rating", null: false
    t.integer "reviewee_id", null: false
    t.integer "reviewer_id", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_reviews_on_job_id"
    t.index ["reviewer_id", "reviewee_id", "job_id"], name: "index_reviews_on_reviewer_id_and_reviewee_id_and_job_id", unique: true
  end

  create_table "skills", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "proficiency"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_skills_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "bio"
    t.text "certifications"
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.datetime "email_confirmed_at"
    t.text "employment_history"
    t.string "encrypted_password", default: "", null: false
    t.decimal "hourly_rate", precision: 8, scale: 2
    t.string "hours_per_week"
    t.string "name", null: false
    t.string "profile_picture"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "client", null: false
    t.text "skills"
    t.string "unconfirmed_email"
    t.datetime "updated_at", null: false
    t.text "work_history"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "contracts", "jobs"
  add_foreign_key "contracts", "proposals"
  add_foreign_key "contracts", "users", column: "client_id"
  add_foreign_key "contracts", "users", column: "freelancer_id"
  add_foreign_key "conversations", "users", column: "client_id"
  add_foreign_key "conversations", "users", column: "freelancer_id"
  add_foreign_key "jobs", "users"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "payments", "jobs"
  add_foreign_key "payments", "users"
  add_foreign_key "proposals", "jobs"
  add_foreign_key "proposals", "users"
  add_foreign_key "reviews", "jobs"
  add_foreign_key "reviews", "users", column: "reviewee_id"
  add_foreign_key "reviews", "users", column: "reviewer_id"
  add_foreign_key "skills", "users"
end
