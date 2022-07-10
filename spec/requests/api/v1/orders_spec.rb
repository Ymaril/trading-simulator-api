require 'swagger_helper'

RSpec.describe 'api/v1/orders', type: :request do
  let!(:current_user) { create(:user) }

  let(:now) { DateTime.now }

  path '/api/v1/orders' do
    get('index') do
      security [api_key: []]

      include_context 'auth'

      consumes 'application/json'

      response(200, 'successful') do
        before do
          create_list(:order, 2, user: current_user)
          create_list(:order, 2)
        end

        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json["results"].count).to eq(2)
          expect(response_json).to include("meta" => {"total_count" => 2})
        end
      end
    end

    post('create') do
      security [api_key: []]

      include_context 'auth'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          from_currency_id: { type: :number },
          to_currency_id: { type: :number },
          value: { type: :number },
          expires_at: { type: :string, format: 'date-time' },
          complete_type: { type: :string, enum: ['take_profit', 'stop_loss'] }
        },
        required: ['from_currency_id', 'to_currency_id', 'value']
      }

      let(:from_currency) { create(:currency, code: 'USD', name: 'Dollar') }
      let(:to_currency) { create(:currency, code: 'BTC', name: 'Bitcoin') }
      let(:value) { 10 }
      let(:expires_at) { now + 15.minutes }
      let(:complete_type) { 'take_profit' }

      let(:params) do 
        {
          from_currency_id: from_currency.id,
          to_currency_id: to_currency.id,
          value: value,
          expires_at: expires_at,
          complete_type: complete_type
        }
      end

      consumes 'application/json'

      response(201, 'successful') do
        before do
          create(:account, currency: from_currency, user: current_user)
        end

        run_test! do |response|
          response_json = JSON.parse(response.body)

          expect(response_json).to include(
            "value" => 10,
            "complete_type" => 'take_profit',
            "completed_at" => nil,
            "state" => "created",
            "from_currency" => {"code" => 'USD', "name" => 'Dollar', "id" => from_currency.id},
            "to_currency" => {"code" => 'BTC', "name" => 'Bitcoin', "id" => to_currency.id},
            "expires_at" => (now + 15.minutes).utc.as_json
          )
          expect(Order.where(from_currency_id: from_currency.id, to_currency_id: to_currency.id, value: value)).to exist
        end
      end

      response(422, 'invalid request') do
        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to include("error" => "User not have currency account")
        end
      end
    end
  end

  path '/api/v1/orders/{id}' do
    parameter name: :id, in: :path, type: :number

    let(:from_currency) { create(:currency, code: 'USD', name: 'Dollar') }
    let(:to_currency) { create(:currency, code: 'BTC', name: 'Bitcoin') }
    let(:value) { 10 }
    let(:expires_at) { now + 15.minutes }
    let(:completed_at) { now - 15.minutes }
    let(:complete_type) { 'take_profit' }
    let(:user) { current_user }
    let(:state) { :created }

    let!(:order) do
      create(
        :order,
        from_currency_id: from_currency.id,
        to_currency_id: to_currency.id,
        value: value,
        expires_at: expires_at,
        complete_type: complete_type,
        user: user,
        completed_at: completed_at,
        state: state
      )
    end
    let(:id) { order.id }

    get('show') do
      security [api_key: []]

      include_context 'auth'

      consumes 'application/json'

      response(200, 'successful') do
        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to include(
            "value" => 10,
            "complete_type" => 'take_profit',
            "completed_at" => (now - 15.minutes).utc.as_json,
            "state" => "created",
            "from_currency" => {"code" => 'USD', "name" => 'Dollar', "id" => from_currency.id},
            "to_currency" => {"code" => 'BTC', "name" => 'Bitcoin', "id" => to_currency.id},
            "expires_at" => (now + 15.minutes).utc.as_json
          )
        end
      end

      response(404, 'Not found') do
        let!(:user) { create(:user) }

        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to include("error" => 'not_found')
        end
      end
    end

    delete('destroy') do
      security [api_key: []]

      include_context 'auth'

      consumes 'application/json'

      response(200, 'successful') do
        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to include(
            "value" => 10,
            "complete_type" => 'take_profit',
            "completed_at" => (now - 15.minutes).utc.as_json,
            "state" => "canceled",
            "from_currency" => {"code" => 'USD', "name" => 'Dollar', "id" => from_currency.id},
            "to_currency" => {"code" => 'BTC', "name" => 'Bitcoin', "id" => to_currency.id},
            "expires_at" => (now + 15.minutes).utc.as_json
          )
          expect(order.reload).to be_canceled
        end
      end

      response(404, 'Not found') do
        let!(:user) { create(:user) }

        run_test! do |response|
          response_json = JSON.parse(response.body)
          expect(response_json).to include("error" => 'not_found')
        end
      end
    end
  end
end

