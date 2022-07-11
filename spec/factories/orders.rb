# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    association :user
    association :to_currency, factory: :currency
    association :from_currency, factory: :currency
    state { %i[created completed canceled].sample }
    complete_type { %i[take_profit stop_loss].sample }
    value { rand(0..100) }
    completed_at do
      if rand(0..10) > 3
        nil
      else
        rand((DateTime.now - 1.year)..DateTime.now)
      end
    end
    expires_at do
      if rand(0..10) > 3
        nil
      else
        rand(DateTime.now..(DateTime.now + 1.year))
      end
    end
  end
end
