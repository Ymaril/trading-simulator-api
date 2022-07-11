# frozen_string_literal: true

FactoryBot.define do
  factory :currency do
    code do
      code = Faker::Currency.code

      code = Faker::Currency.code while Currency.pluck(:code).include? code

      code
    end
    name { Faker::Currency.name }
  end
end
