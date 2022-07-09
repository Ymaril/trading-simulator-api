class User < ApplicationRecord
  has_secure_password

  has_many :accounts

  validates :email, uniqueness: true
end
