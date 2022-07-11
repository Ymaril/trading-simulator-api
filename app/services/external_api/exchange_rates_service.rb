# frozen_string_literal: true

module ExternalApi
  class ExchangeRatesService
    include HTTParty

    base_uri 'https://api.apilayer.com'

    class << self
      def get_rates(currency_codes)
        response = get(
          '/fixer/latest',
          query: { base: 'USD', symbols: currency_codes.join(',') },
          headers: headers
        )

        response['rates']
      end

      private

      def headers
        { apikey: token }
      end

      def token
        ENV['CURRENCY_API_KEY']
      end
    end
  end
end
