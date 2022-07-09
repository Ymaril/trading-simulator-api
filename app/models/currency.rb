class Currency < ApplicationRecord
  validates :code, :name, presence: true
  validates :code, uniqueness: true

  has_many :accounts
end
