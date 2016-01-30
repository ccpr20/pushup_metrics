# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160130091337) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pushups", force: :cascade do |t|
    t.string   "amount"
    t.datetime "date",       null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

  add_index "pushups", ["team_id"], name: "index_pushups_on_team_id", using: :btree
  add_index "pushups", ["user_id"], name: "index_pushups_on_user_id", using: :btree

  create_table "pushups_teams", id: false, force: :cascade do |t|
    t.integer "pushup_id"
    t.integer "team_id"
  end

  add_index "pushups_teams", ["pushup_id", "team_id"], name: "index_pushups_teams_on_pushup_id_and_team_id", using: :btree
  add_index "pushups_teams", ["team_id"], name: "index_pushups_teams_on_team_id", using: :btree

  create_table "reminders", force: :cascade do |t|
    t.string   "phone_number"
    t.time     "time"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "user_id"
    t.string   "time_zone"
  end

  add_index "reminders", ["user_id"], name: "index_reminders_on_user_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "subdomain"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams_users", id: false, force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
  end

  add_index "teams_users", ["team_id", "user_id"], name: "index_teams_users_on_team_id_and_user_id", using: :btree
  add_index "teams_users", ["user_id"], name: "index_teams_users_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "company"
    t.string   "company_website"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
