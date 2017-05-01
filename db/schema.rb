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

ActiveRecord::Schema.define(version: 20170429023508) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookpages", force: :cascade do |t|
    t.integer  "pagenum",      default: 0
    t.string   "bgcolor",      default: "white"
    t.integer  "template",     default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "images",       default: [],                   array: true
    t.string   "positions",    default: [],                   array: true
    t.integer  "book_id"
    t.integer  "phgallery_id"
  end

  add_index "bookpages", ["book_id"], name: "index_bookpages_on_book_id", using: :btree
  add_index "bookpages", ["phgallery_id"], name: "index_bookpages_on_phgallery_id", using: :btree

  create_table "bookprices", force: :cascade do |t|
    t.string   "format"
    t.string   "status",        default: "АКТИВЕН"
    t.string   "default",       default: "НЕТ"
    t.integer  "minpagescount", default: 20
    t.integer  "maxpagescount", default: 30
    t.integer  "coverprice",    default: 0
    t.integer  "twopageprice",  default: 0
    t.integer  "coverwidth",    default: 0
    t.integer  "coverheight",   default: 0
    t.integer  "twopagewidth",  default: 0
    t.integer  "twopageheight", default: 0
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "books", force: :cascade do |t|
    t.integer  "price",        default: 0
    t.string   "name",         default: "My photobook"
    t.string   "fontfamily",   default: "PT Sans"
    t.string   "fontcolor",    default: "black"
    t.string   "fontsize",     default: "6"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "user_id"
    t.integer  "bookprice_id"
  end

  add_index "books", ["bookprice_id"], name: "index_books_on_bookprice_id", using: :btree
  add_index "books", ["user_id"], name: "index_books_on_user_id", using: :btree

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "ckeditor_assets", ["type"], name: "index_ckeditor_assets_on_type", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "deliveries", force: :cascade do |t|
    t.string   "name"
    t.integer  "price",      default: 0
    t.string   "default",    default: "НЕТ"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "discounts", force: :cascade do |t|
    t.string   "name"
    t.integer  "value",      default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string   "name"
    t.integer  "bookscount",  default: 0
    t.string   "fio"
    t.string   "phone"
    t.integer  "zipcode",     default: 0
    t.string   "city"
    t.string   "address"
    t.string   "email"
    t.string   "comment"
    t.integer  "price",       default: 0
    t.string   "status",      default: "Создан"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "book_id"
    t.integer  "delivery_id"
  end

  add_index "orders", ["book_id"], name: "index_orders_on_book_id", using: :btree
  add_index "orders", ["delivery_id"], name: "index_orders_on_delivery_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "partners", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "attachment"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "phgalleries", force: :cascade do |t|
    t.string   "kind",       default: "book"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "images",     default: [],                  array: true
    t.integer  "book_id"
    t.string   "imgchecks",  default: [],                  array: true
  end

  add_index "phgalleries", ["book_id"], name: "index_phgalleries_on_book_id", using: :btree

  create_table "socialicons", force: :cascade do |t|
    t.string   "name"
    t.string   "iconlink"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.integer  "role"
    t.string   "provider"
    t.string   "uid"
    t.string   "username"
    t.string   "nickname"
    t.string   "url"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "bookpages", "books"
  add_foreign_key "bookpages", "phgalleries"
  add_foreign_key "books", "bookprices"
  add_foreign_key "books", "users"
  add_foreign_key "orders", "books"
  add_foreign_key "orders", "deliveries"
  add_foreign_key "phgalleries", "books"
end
