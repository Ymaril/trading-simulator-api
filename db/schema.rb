# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_220_712_145_540) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'accounts', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.bigint 'currency_id', null: false
    t.integer 'balance', default: 0, null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['currency_id'], name: 'index_accounts_on_currency_id'
    t.index ['user_id'], name: 'index_accounts_on_user_id'
  end

  create_table 'currencies', force: :cascade do |t|
    t.string 'code', null: false
    t.string 'name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.float 'latest_rate'
  end

  create_table 'orders', force: :cascade do |t|
    t.bigint 'from_currency_id', null: false
    t.bigint 'to_currency_id', null: false
    t.bigint 'user_id', null: false
    t.integer 'value', default: 0, null: false
    t.datetime 'expires_at'
    t.datetime 'completed_at'
    t.string 'state', default: 'created', null: false
    t.string 'complete_type', default: 'take_profit', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'expected_value', default: 0, null: false
    t.index ['from_currency_id'], name: 'index_orders_on_from_currency_id'
    t.index ['to_currency_id'], name: 'index_orders_on_to_currency_id'
    t.index ['user_id'], name: 'index_orders_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'email'
    t.string 'password_digest'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.boolean 'admin', default: false, null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
  end
end
