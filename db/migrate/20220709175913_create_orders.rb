# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.belongs_to :from_currency, null: false
      t.belongs_to :to_currency, null: false
      t.belongs_to :user, null: false
      t.integer :value, null: false, default: 0
      t.datetime :expires_at, default: nil
      t.datetime :completed_at, default: nil
      t.string :state, default: 'created', null: false

      t.string :complete_type, null: false, default: 'take_profit'

      t.timestamps
    end
  end
end
