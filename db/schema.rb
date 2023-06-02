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

ActiveRecord::Schema[7.0].define(version: 2023_05_29_181919) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campaigns", force: :cascade do |t|
    t.string "name"
    t.boolean "reviewed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "campaign_id"
    t.decimal "grand_total", precision: 24, scale: 14
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_invoices_on_campaign_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.bigint "invoice_id"
    t.bigint "campaign_id"
    t.string "name"
    t.decimal "booked_amount", precision: 24, scale: 14
    t.decimal "actual_amount", precision: 24, scale: 14
    t.decimal "adjustments", precision: 24, scale: 14
    t.boolean "reviewed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_line_items_on_campaign_id"
    t.index ["invoice_id"], name: "index_line_items_on_invoice_id"
  end

  add_foreign_key "invoices", "campaigns"
  add_foreign_key "line_items", "campaigns"
  add_foreign_key "line_items", "invoices"
end
