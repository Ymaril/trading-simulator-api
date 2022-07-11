# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/accounts', type: :request do
  let!(:current_user) { create(:user) }

  path '/api/v1/accounts' do
    get('index') do
      security [api_key: []]

      tags 'Accounts'

      include_context 'auth'

      consumes 'application/json'

      response(200, 'successful') do
        before do
          create_list(:account, 2, user: current_user)
          create_list(:account, 2)
        end

        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json['results'].count).to eq(2)
          expect(response_json).to include('meta' => { 'total_count' => 2 })
        end
      end
    end

    post('create') do
      security [api_key: []]

      tags 'Accounts'

      include_context 'auth'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          currency_id: { type: :number }
        },
        required: ['currency_id']
      }

      let(:currency) { create(:currency, code: 'USD', name: 'Dollar') }

      let(:params) { { currency_id: currency.id } }

      consumes 'application/json'

      response(201, 'successful') do
        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to include(
            'balance' => 0,
            'currency' => { 'code' => 'USD', 'name' => 'Dollar', 'id' => currency.id }
          )
          expect(Currency.where(code: 'USD', name: 'Dollar')).to exist
        end
      end

      response(422, 'invalid request') do
        before { create(:account, user: current_user, currency: currency) }

        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to include('error' => 'Account: Currency has already been taken')
        end
      end
    end
  end

  path '/api/v1/accounts/{id}' do
    parameter name: :id, in: :path, type: :number

    get('show') do
      security [api_key: []]

      tags 'Accounts'

      include_context 'auth'

      consumes 'application/json'

      response(200, 'successful') do
        let(:currency) { create(:currency, name: 'Dollar', code: 'USD') }
        let!(:account) { create(:account, user: current_user, balance: 5, currency: currency) }
        let(:id) { account.id }

        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to match(
            'balance' => 5,
            'currency' => { 'code' => 'USD', 'name' => 'Dollar', 'id' => currency.id },
            'id' => account.id
          )
        end
      end

      response(404, 'Not found') do
        let!(:account) { create(:account) }
        let(:id) { account.id }

        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to include('error' => 'not_found')
        end
      end
    end

    delete('destroy') do
      security [api_key: []]

      tags 'Accounts'

      include_context 'auth'

      consumes 'application/json'

      response(200, 'successful') do
        let(:currency) { create(:currency, name: 'Dollar', code: 'USD') }
        let!(:account) { create(:account, user: current_user, balance: 5, currency: currency) }
        let(:id) { account.id }

        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to match(
            'balance' => 5,
            'currency' => { 'code' => 'USD', 'name' => 'Dollar', 'id' => currency.id },
            'id' => account.id
          )
          expect(Account.where(user: current_user, currency: currency)).to_not exist
        end
      end

      response(404, 'Not found') do
        let!(:account) { create(:account) }
        let(:id) { account.id }

        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to include('error' => 'not_found')
        end
      end
    end
  end

  path '/api/v1/accounts/{id}/charge' do
    parameter name: :id, in: :path, type: :number
    parameter name: :params, in: :body, schema: {
      type: :object,
      properties: {
        value: { type: :number }
      },
      required: ['value']
    }

    let(:params) { { value: value } }

    patch('charge') do
      security [api_key: []]

      tags 'Accounts'

      include_context 'auth'

      consumes 'application/json'

      let(:currency) { create(:currency, name: 'Dollar', code: 'USD') }
      let!(:account) { create(:account, user: current_user, balance: 100, currency: currency) }
      let(:id) { account.id }
      let(:value) { 5 }

      response(200, 'successful') do
        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to match(
            'balance' => 105,
            'currency' => { 'code' => 'USD', 'name' => 'Dollar', 'id' => currency.id },
            'id' => account.id
          )
          expect(Account.where(user: current_user, currency: currency, balance: 105)).to exist
        end
      end

      response(422, 'Invalid request') do
        let(:value) { -3 }

        run_test! do |_response|
          expect(account.reload.balance).to eql(100)
        end
      end

      response(404, 'Not found') do
        let!(:account) { create(:account) }

        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to include('error' => 'not_found')
        end
      end
    end
  end
end
