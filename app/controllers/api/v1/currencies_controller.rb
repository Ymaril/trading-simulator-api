# frozen_string_literal: true

module Api
  module V1
    class CurrenciesController < Api::V1::V1Controller
      before_action :set_currency, only: %w[show]
      before_action :set_scope, only: %w[index]

      def index
        result = CurrenciesFetcher.new @scope

        render json: {
          results: CurrencySerializer.render_as_hash(result.build(params)),
          meta: result.meta
        }
      end

      def show
        render json: CurrencySerializer.render_as_hash(@currency)
      end

      private

      def set_currency
        @currency = Currency.find(params[:id])
      end

      def set_scope
        @scope = Currency.all
      end
    end
  end
end
