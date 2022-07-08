require 'swagger_helper'

# We use the api_guard gem. He has own specs. Here we describe the swagger specification
RSpec.describe 'api_guard/passwords', type: :request do

  path '/api/v1/users/passwords' do
    let!(:user) do
      create(:user, password: 'old_password')
    end

    patch('update password') do
      security [api_key: []]

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          password: {type: :string}
        },
        required: ['password']
      }

      consumes 'application/json'

      let(:jwt_payload) do
        {
          user_id: user.id,
          exp: (Time.now.utc + 10.minutes).to_i,
          iat: Time.now.utc.to_i
        }
      end
      let(:api_key) do
        Class.new { include ApiGuard::JwtAuth::JsonWebToken }.new.encode(jwt_payload) 
      end
      let(:Authorization) { "Bearer #{api_key}"}

      let(:credentials) { {password: 'new_password'} }

      response(200, 'successful') do
        run_test! do |response|
          expect(user.reload.authenticate('new_password')).to be_truthy
        end
      end
    end
  end
end
