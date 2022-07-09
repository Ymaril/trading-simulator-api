class Account < ApplicationRecord
  belongs_to :user
  belongs_to :currency

  validates :currency_id, uniqueness: {scope: :user_id}
end
