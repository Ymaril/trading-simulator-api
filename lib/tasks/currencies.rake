# frozen_string_literal: true

namespace :currencies do
  desc 'Update latest rates'
  task update_rates: :environment do
    codes = Currency.pluck(:code)

    rates = ExternalApi::ExchangeRatesService.get_rates(codes)

    rates.each do |code, value|
      Currency.where(code: code).update(latest_rate: value)
    end
  end
end
