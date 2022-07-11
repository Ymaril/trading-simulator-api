# frozen_string_literal: true

class CurrencySerializer < Blueprinter::Base
  identifier :id

  fields :code, :name
end
