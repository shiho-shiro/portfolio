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

ActiveRecord::Schema.define(version: 2022_04_27_025043) do

  create_table "advices", charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "concern_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "advice"
  end

  create_table "concerns", charset: "utf8mb4", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "image"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "country_code", default: "JP"
  end

  create_table "likes", charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "recommend_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "memories", charset: "utf8mb4", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.date "date"
    t.string "image"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notifications", charset: "utf8mb4", force: :cascade do |t|
    t.integer "visiter_id"
    t.integer "visited_id"
    t.integer "concern_id"
    t.integer "advice_id"
    t.integer "recommend_id"
    t.string "action"
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "recommends", charset: "utf8mb4", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.string "image"
    t.string "country_code", default: "JP"
    t.integer "user_id"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.string "image"
    t.string "country_code", default: "JP"
    t.string "job"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
