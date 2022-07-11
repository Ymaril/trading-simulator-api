# frozen_string_literal: true

class AccountSerializer < Blueprinter::Base
  identifier :id

  fields :balance
  association :currency, blueprint: CurrencySerializer
end
