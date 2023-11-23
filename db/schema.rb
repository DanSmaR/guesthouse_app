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

ActiveRecord::Schema[7.1].define(version: 2023_11_23_144110) do
  create_table "addresses", force: :cascade do |t|
    t.string "street", null: false
    t.string "neighborhood", null: false
    t.string "city", null: false
    t.string "postal_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state"
  end

  create_table "booking_rates", force: :cascade do |t|
    t.integer "booking_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.decimal "rate", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_booking_rates_on_booking_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.date "check_in_date", null: false
    t.date "check_out_date", null: false
    t.integer "number_of_guests", null: false
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "guest_id", null: false
    t.integer "status", default: 0, null: false
    t.string "reservation_code", null: false
    t.datetime "check_in_hour", null: false
    t.datetime "check_out_hour", null: false
    t.integer "total_price", null: false
    t.date "check_in_confirmed_date"
    t.date "check_out_confirmed_date"
    t.datetime "check_in_confirmed_hour"
    t.datetime "check_out_confirmed_hour"
    t.integer "total_paid"
    t.string "payment_method"
    t.index ["guest_id"], name: "index_bookings_on_guest_id"
    t.index ["reservation_code"], name: "index_bookings_on_reservation_code", unique: true
    t.index ["room_id"], name: "index_bookings_on_room_id"
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
    t.datetime "checkin_hour", default: "2023-11-23 17:00:00"
    t.datetime "checkout_hour", default: "2023-11-23 15:00:00"
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

  create_table "guests", force: :cascade do |t|
    t.string "name", null: false
    t.string "surname", null: false
    t.string "identification_register_number", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_guests_on_user_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.integer "method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating", null: false
    t.text "comment"
    t.integer "guest_id", null: false
    t.integer "booking_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "response"
    t.index ["booking_id"], name: "index_reviews_on_booking_id"
    t.index ["guest_id"], name: "index_reviews_on_guest_id"
  end

  create_table "room_rates", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.decimal "daily_rate", default: "0.0", null: false
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_room_rates_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "size", null: false
    t.integer "max_people", null: false
    t.decimal "daily_rate", null: false
    t.boolean "bathroom", default: false
    t.boolean "balcony", default: false
    t.boolean "air_conditioning", default: false
    t.boolean "tv", default: false
    t.boolean "wardrobe", default: false
    t.boolean "safe", default: false
    t.boolean "accessible", default: false
    t.boolean "available", default: true
    t.integer "guesthouse_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guesthouse_id"], name: "index_rooms_on_guesthouse_id"
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

  add_foreign_key "booking_rates", "bookings"
  add_foreign_key "bookings", "guests"
  add_foreign_key "bookings", "rooms"
  add_foreign_key "guesthouse_owners", "users"
  add_foreign_key "guesthouses", "addresses"
  add_foreign_key "guesthouses", "guesthouse_owners"
  add_foreign_key "guests", "users"
  add_foreign_key "reviews", "bookings"
  add_foreign_key "reviews", "guests"
  add_foreign_key "room_rates", "rooms"
  add_foreign_key "rooms", "guesthouses"
end
