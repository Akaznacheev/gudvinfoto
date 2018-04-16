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

ActiveRecord::Schema.define(version: 20180415164018) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "book_pages", id: :serial, force: :cascade do |t|
    t.integer "page_num", default: 0
    t.string "background_color", default: "white"
    t.integer "template", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "images", default: [], array: true
    t.string "positions", default: [], array: true
    t.integer "book_id"
    t.integer "gallery_id"
    t.string "background"
    t.index ["book_id"], name: "index_book_pages_on_book_id"
    t.index ["gallery_id"], name: "index_book_pages_on_gallery_id"
  end

  create_table "books", id: :serial, force: :cascade do |t|
    t.integer "price", default: 0
    t.string "name", default: "My photobook"
    t.string "font_family", default: "PT Sans"
    t.string "font_color", default: "black"
    t.string "font_size", default: "6"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "price_list_id"
    t.index ["price_list_id"], name: "index_books_on_price_list_id"
    t.index ["user_id"], name: "index_books_on_user_id"
  end

  create_table "changes", force: :cascade do |t|
    t.string "description"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "deliveries", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "price", default: 0
    t.string "default", default: "НЕТ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discounts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "value", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "galleries", id: :serial, force: :cascade do |t|
    t.string "kind", default: "book"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "images", default: [], array: true
    t.integer "book_id"
    t.string "added_images", default: [], array: true
    t.index ["book_id"], name: "index_galleries_on_book_id"
  end

  create_table "holsts", force: :cascade do |t|
    t.string "format"
    t.integer "price", default: 0
    t.string "image"
    t.string "positions", default: "0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "price_list_id"
    t.bigint "user_id"
    t.index ["price_list_id"], name: "index_holsts_on_price_list_id"
    t.index ["user_id"], name: "index_holsts_on_user_id"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "books_count", default: 0
    t.string "fio"
    t.string "phone"
    t.integer "zip_code", default: 0
    t.string "city"
    t.string "address"
    t.string "email"
    t.string "comment"
    t.integer "price", default: 0
    t.string "status", default: "Создан"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "book_id"
    t.integer "delivery_id"
    t.string "kind", default: "book"
    t.integer "holst_id"
    t.index ["book_id"], name: "index_orders_on_book_id"
    t.index ["delivery_id"], name: "index_orders_on_delivery_id"
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "partners", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "attachment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
  end

  create_table "price_lists", id: :serial, force: :cascade do |t|
    t.string "format"
    t.string "status", default: "АКТИВЕН"
    t.string "default", default: "НЕТ"
    t.integer "min_pages_count", default: 20
    t.integer "max_pages_count", default: 30
    t.integer "cover_price", default: 0
    t.integer "twopage_price", default: 0
    t.integer "cover_width", default: 0
    t.integer "cover_height", default: 0
    t.integer "twopage_width", default: 0
    t.integer "twopage_height", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "kind", default: "book"
    t.integer "holst_price", default: 0
  end

  create_table "social_icons", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "icon_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
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
    t.integer "role"
    t.string "provider"
    t.string "uid"
    t.string "username"
    t.string "nickname"
    t.string "url"
    t.boolean "guest", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "book_pages", "books"
  add_foreign_key "book_pages", "galleries"
  add_foreign_key "books", "price_lists"
  add_foreign_key "books", "users"
  add_foreign_key "galleries", "books"
  add_foreign_key "holsts", "price_lists"
  add_foreign_key "holsts", "users"
  add_foreign_key "orders", "books"
  add_foreign_key "orders", "deliveries"
end
