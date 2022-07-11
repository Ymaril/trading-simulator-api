# frozen_string_literal: true

class AddExpectedValueToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :expected_value, :integer, null: false, default: 0
  end
end
