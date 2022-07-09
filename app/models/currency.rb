class Currency < ApplicationRecord
  validates :code, :name, presence: true
  validates :code, uniqueness: true

  has_many :accounts
  has_many :orders, ->(currency) { unscope(:where).where("from_currency_id = :id OR to_currency_id = :id", id: currency.id) }
end
