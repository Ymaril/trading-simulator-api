require 'swagger_helper'

# We use the api_guard gem. He has own specs. Here we describe the swagger specification
RSpec.describe 'api_guard/authentication', type: :request do

  path '/api/v1/users/sign_in' do

    let!(:user) do
      create(:user, password: user_password, email: user_email)
    end

    post('create authentication') do
      consumes 'application/json'

      let(:user_email) { 'qwe@qwe.qwe' }
      let(:user_password) { 'qweqweqwe' }

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: [ 'email', 'password' ]
      }

      response(200, 'successful') do
        let(:credentials) { {email: user_email, password: user_password} }

        header 'access-token', schema: {type: :string}, description: 'Json Web Token'

        run_test!
      end

      response(422, 'invalid request') do
        let(:credentials) { {email: 'another@email.com', password: user_password} }

        run_test!
      end
    end
  end

  path '/api/v1/users/sign_out' do
    let(:current_user) { create(:user) }

    delete('delete authentication') do
      security [api_key: []]

      consumes 'application/json'

      include_context 'auth'

      response(200, 'successful') do
        run_test!
      end
    end
  end
end
