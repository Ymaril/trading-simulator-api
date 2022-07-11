# frozen_string_literal: true

class CreateCurrencies < ActiveRecord::Migration[6.1]
  def change
    create_table :currencies do |t|
      t.string :code, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
