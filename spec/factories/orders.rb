FactoryBot.define do
  factory :order do
    association :user
    association :to_currency, factory: :currency
    association :from_currency, factory: :currency
    complete_type { 'take_profit' }
    value { rand(0..100) }
  end
end
