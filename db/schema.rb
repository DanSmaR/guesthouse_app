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

ActiveRecord::Schema[7.1].define(version: 2023_11_01_233908) do
  create_table "addresses", force: :cascade do |t|
    t.string "street", null: false
    t.string "neighborhood", null: false
    t.string "city", null: false
    t.string "postal_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state"
  end

  create_table "guesthouse_owners", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_guesthouse_owners_on_user_id"
  end

  create_table "guesthouses", force: :cascade do |t|
    t.string "corporate_name", null: false
    t.string "brand_name", null: false
    t.string "registration_code", null: false
    t.string "phone_number", null: false
    t.string "email", null: false
    t.integer "address_id", null: false
    t.integer "guesthouse_owner_id", null: false
    t.text "description"
    t.boolean "pets", default: false
    t.text "use_policy"
    t.datetime "checkin_hour", default: "2023-11-01 17:00:00"
    t.datetime "checkout_hour", default: "2023-11-01 15:00:00"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_guesthouses_on_address_id"
    t.index ["guesthouse_owner_id"], name: "index_guesthouses_on_guesthouse_owner_id"
  end

  create_table "guesthouses_payment_methods", id: false, force: :cascade do |t|
    t.integer "guesthouse_id", null: false
    t.integer "payment_method_id", null: false
  end

  create_table "payment_methods", force: :cascade do |t|
    t.integer "method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "guesthouse_owners", "users"
  add_foreign_key "guesthouses", "addresses"
  add_foreign_key "guesthouses", "guesthouse_owners"
end
