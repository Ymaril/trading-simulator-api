# frozen_string_literal: true

FactoryBot.define do
  factory :currency do
    code do
      code = Faker::Currency.code

      code = Faker::Currency.code while Currency.pluck(:code).include? code

      code
    end
    name { Faker::Currency.name }
    latest_rate { rand(0..1000) }
  end
end
