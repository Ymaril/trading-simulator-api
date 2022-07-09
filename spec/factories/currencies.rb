FactoryBot.define do
  factory :currency do
    code { Faker::Currency.unique.code }
    name { Faker::Currency.name }
  end
end
