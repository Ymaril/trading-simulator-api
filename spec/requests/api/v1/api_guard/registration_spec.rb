require 'swagger_helper'

# We use the api_guard gem. He has own specs. Here we describe the swagger specification
RSpec.describe 'api_guard/registration', type: :request do

  path '/api/v1/users/sign_up' do

    post('create registration') do
      consumes 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: [ 'email', 'password' ]
      }

      response(200, 'successful') do
        let(:credentials) { {email: 'qwe@qwe.qwe', password: 'qweqweqwe'} }

        header 'access-token', schema: {type: :string}, description: 'Json Web Token'

        run_test!
      end

      response(422, 'email in use') do
        before do
          create(:user, email: 'qwe@qwe.qwe')
        end

        let(:credentials) { {email: 'qwe@qwe.qwe', password: 'qweqweqwe'} }

        run_test!
      end
    end
  end
end
