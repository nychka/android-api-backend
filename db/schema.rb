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

ActiveRecord::Schema.define(version: 20150313204743) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "ads", force: true do |t|
    t.string   "name"
    t.string   "price"
    t.integer  "place_id"
    t.string   "photo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ads", ["place_id"], name: "index_ads_on_place_id", using: :btree

  create_table "authentications", force: true do |t|
    t.integer  "user_id",       null: false
    t.string   "provider",      null: false
    t.string   "auth_token",    null: false
    t.string   "refresh_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["provider", "auth_token"], name: "index_authentications_on_provider_and_auth_token", unique: true, using: :btree
  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id", using: :btree

  create_table "places", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
  end

  add_index "places", ["latitude", "longitude"], name: "place_coordinates", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "age"
    t.string   "email"
    t.string   "photo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_token"
    t.datetime "expires_at"
    t.string   "city"
    t.integer  "gender",       limit: 2
    t.date     "bdate"
    t.string   "links",                  array: true
    t.float    "latitude"
    t.float    "longitude"
    t.string   "phone"
  end

  add_index "users", ["access_token"], name: "index_users_on_access_token", unique: true, using: :btree
  add_index "users", ["city"], name: "index_users_on_city", using: :btree
  add_index "users", ["latitude", "longitude"], name: "user_coordinates", using: :btree

end
