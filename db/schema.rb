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

ActiveRecord::Schema[8.1].define(version: 2026_05_30_125859) do
  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "limit", precision: 10, scale: 2
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "amount", default: 1
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.string "name"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "purchased_at"
    t.string "status", default: "pending"
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "frequency"
    t.string "name"
    t.decimal "price", precision: 10, scale: 2
    t.date "start_date"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.decimal "balance", precision: 10, scale: 2, default: "10000.0"
    t.datetime "created_at", null: false
    t.integer "failed_attempts", default: 0
    t.decimal "income", precision: 10, scale: 2, default: "2000.0"
    t.integer "income_day", default: 1
    t.datetime "locked_until"
    t.string "name"
    t.string "password_digest"
    t.boolean "rate_limit_enabled", default: true
    t.integer "role", default: 1
    t.integer "time_offset"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "categories", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "subscriptions", "users"
end
