# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/admin/currencies', type: :request do
  let!(:current_user) { create(:user, admin: true) }

  path '/api/v1/admin/currencies' do
    get('index') do
      security [api_key: []]

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

      response(401, 'forbidden') do
        let!(:current_user) { create(:user, admin: false) }

        run_test!
      end
    end

    post('create') do
      security [api_key: []]

      include_context 'auth'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          code: { type: :string },
          name: { type: :string }
        },
        required: %w[code name]
      }

      let(:params) { { code: 'USD', name: 'Dollar' } }

      consumes 'application/json'

      response(201, 'successful') do
        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to include('code' => 'USD', 'name' => 'Dollar')
          expect(Currency.where(code: 'USD', name: 'Dollar')).to exist
        end
      end

      response(422, 'invalid request') do
        before { create(:currency, code: 'USD', name: 'Dollar') }

        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to include('error' => 'Currency: Code has already been taken')
        end
      end

      response(401, 'forbidden') do
        let!(:current_user) { create(:user, admin: false) }

        run_test!
      end
    end
  end

  path '/api/v1/admin/currencies/{id}' do
    parameter name: :id, in: :path, type: :number

    get('show') do
      security [api_key: []]

      include_context 'auth'

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

      response(401, 'forbidden') do
        let!(:current_user) { create(:user, admin: false) }
        let(:id) { 1 }

        run_test!
      end
    end

    delete('destroy') do
      security [api_key: []]

      include_context 'auth'

      consumes 'application/json'

      response(200, 'successful') do
        let!(:currency) { create(:currency, name: 'Dollar', code: 'USD') }
        let(:id) { currency.id }

        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to include('code' => 'USD', 'name' => 'Dollar')
          expect(Currency.where(code: 'USD', name: 'Dollar')).to_not exist
        end
      end

      response(404, 'Not found') do
        let(:id) { 1 }

        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to include('error' => 'not_found')
        end
      end

      response(401, 'forbidden') do
        let!(:current_user) { create(:user, admin: false) }
        let(:id) { 1 }

        run_test!
      end
    end
  end
end
