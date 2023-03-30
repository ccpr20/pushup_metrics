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

ActiveRecord::Schema.define(version: 2023_03_30_232112) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pushups", force: :cascade do |t|
    t.integer "amount"
    t.datetime "date", null: false
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "team_id"
    t.index ["team_id"], name: "index_pushups_on_team_id"
    t.index ["user_id"], name: "index_pushups_on_user_id"
  end

  create_table "pushups_teams", id: false, force: :cascade do |t|
    t.integer "pushup_id"
    t.integer "team_id"
    t.index ["pushup_id", "team_id"], name: "index_pushups_teams_on_pushup_id_and_team_id"
    t.index ["team_id"], name: "index_pushups_teams_on_team_id"
  end

  create_table "reminders", force: :cascade do |t|
    t.string "phone_number"
    t.time "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "time_zone"
    t.index ["user_id"], name: "index_reminders_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "subdomain"
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams_users", id: false, force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
    t.index ["team_id", "user_id"], name: "index_teams_users_on_team_id_and_user_id"
    t.index ["user_id"], name: "index_teams_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "company"
    t.string "company_website"
    t.integer "total_pushups_cache", default: 0
    t.string "country", default: "USA", null: false
    t.integer "age"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
