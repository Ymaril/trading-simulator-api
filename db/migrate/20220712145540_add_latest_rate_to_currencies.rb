# frozen_string_literal: true

class AddLatestRateToCurrencies < ActiveRecord::Migration[6.1]
  def change
    add_column :currencies, :latest_rate, :float
  end
end
