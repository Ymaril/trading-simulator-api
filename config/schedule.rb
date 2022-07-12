# frozen_string_literal: true

every 1.minute do
  rake 'currencies:update_rates'
end
