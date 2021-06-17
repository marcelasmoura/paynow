# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_17_180341) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "business_registers", force: :cascade do |t|
    t.string "corporate_name"
    t.string "billing_address"
    t.string "state"
    t.string "zip_code"
    t.string "billing_email"
    t.string "cnpj"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "token"
    t.string "domain"
  end

  create_table "customers", force: :cascade do |t|
    t.string "full_name"
    t.string "cpf"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "payment_method_options", force: :cascade do |t|
    t.integer "payment_method_id", null: false
    t.string "cod_febraban"
    t.decimal "discount"
    t.string "token"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["payment_method_id"], name: "index_payment_method_options_on_payment_method_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.decimal "charge_fee"
    t.decimal "minimum_fee"
    t.boolean "available"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.string "token"
    t.boolean "active"
    t.integer "payment_method_option_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["payment_method_option_id"], name: "index_products_on_payment_method_option_id"
  end

  create_table "register_customers", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "business_register_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["business_register_id"], name: "index_register_customers_on_business_register_id"
    t.index ["customer_id"], name: "index_register_customers_on_customer_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "business_register_id", null: false
    t.integer "payment_method_option_id", null: false
    t.integer "product_id", null: false
    t.integer "customer_id", null: false
    t.decimal "full_price"
    t.decimal "discount"
    t.decimal "net_price"
    t.string "token"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["business_register_id"], name: "index_transactions_on_business_register_id"
    t.index ["customer_id"], name: "index_transactions_on_customer_id"
    t.index ["payment_method_option_id"], name: "index_transactions_on_payment_method_option_id"
    t.index ["product_id"], name: "index_transactions_on_product_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role"
    t.integer "business_register_id"
    t.boolean "pending"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "payment_method_options", "payment_methods"
  add_foreign_key "products", "payment_method_options"
  add_foreign_key "register_customers", "business_registers"
  add_foreign_key "register_customers", "customers"
  add_foreign_key "transactions", "business_registers"
  add_foreign_key "transactions", "customers"
  add_foreign_key "transactions", "payment_method_options"
  add_foreign_key "transactions", "products"
end
