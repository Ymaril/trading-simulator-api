# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.belongs_to :user, null: false
      t.belongs_to :currency, null: false
      t.integer :balance, null: false, default: 0

      t.timestamps
    end
  end
end
