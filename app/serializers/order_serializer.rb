# frozen_string_literal: true

class OrderSerializer < Blueprinter::Base
  identifier :id

  fields :value, :expires_at, :completed_at, :state, :complete_type

  association :from_currency, blueprint: CurrencySerializer
  association :to_currency, blueprint: CurrencySerializer
end
