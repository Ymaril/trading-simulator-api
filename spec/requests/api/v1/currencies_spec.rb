# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/currencies', type: :request do
  let!(:current_user) { create(:user) }

  path '/api/v1/currencies' do
    get('index') do
      security [api_key: []]

      tags 'Currencies'

      include_context 'auth'

      consumes 'application/json'

      response(200, 'successful') do
        before do
          create(:currency, name: 'Dollar', code: 'USD')
          create(:currency, name: 'Ruble', code: 'RUB')
        end

        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json['results'].count).to eq(2)
          expect(response_json).to include('meta' => { 'total_count' => 2 })
        end
      end
    end
  end

  path '/api/v1/currencies/{id}' do
    get('show') do
      security [api_key: []]

      tags 'Currencies'

      include_context 'auth'

      parameter name: :id, in: :path, type: :number

      consumes 'application/json'

      response(200, 'successful') do
        let!(:currency) { create(:currency, name: 'Dollar', code: 'USD') }
        let(:id) { currency.id }

        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to include('code' => 'USD', 'name' => 'Dollar')
        end
      end

      response(404, 'Not found') do
        let(:id) { 1 }

        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to include('error' => 'not_found')
        end
      end
    end
  end
end
