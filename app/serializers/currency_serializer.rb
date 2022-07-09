class CurrencySerializer < Blueprinter::Base
  identifier :id

  fields :code, :name
end
