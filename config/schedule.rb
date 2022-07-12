# frozen_string_literal: true

# currency api update rates one time in day
every 1.day do
  rake 'currencies:update_rates'
end

every 1.day do
  rake 'orders:perform'
end

every 5.minutes do
  rake 'orders:cancel'
end