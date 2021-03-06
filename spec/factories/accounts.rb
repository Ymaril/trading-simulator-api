# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    association :user
    association :currency
    balance { 0 }
  end
end
