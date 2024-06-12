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

ActiveRecord::Schema[7.2].define(version: 2024_06_11_183349) do
  create_table "refer_referral_codes", force: :cascade do |t|
    t.string "referrer_type", null: false
    t.integer "referrer_id", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "referrer_type", "referrer_id" ], name: "index_refer_referral_codes_on_referrer"
  end

  create_table "refer_referrals", force: :cascade do |t|
    t.string "referrer_type", null: false
    t.integer "referrer_id", null: false
    t.string "referee_type", null: false
    t.integer "referee_id", null: false
    t.integer "referral_code_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "referee_type", "referee_id" ], name: "index_refer_referrals_on_referee"
    t.index [ "referral_code_id" ], name: "index_refer_referrals_on_referral_code_id"
    t.index [ "referrer_type", "referrer_id" ], name: "index_refer_referrals_on_referrer"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
