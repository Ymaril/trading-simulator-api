require 'swagger_helper'

# We use the api_guard gem. He has own specs. Here we describe the swagger specification
RSpec.describe 'api_guard/passwords', type: :request do
  path '/api/v1/users/passwords' do
    let!(:current_user) do
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

      include_context "auth"

      let(:credentials) { {password: 'new_password'} }

      response(200, 'successful') do
        run_test! do |response|
          expect(current_user.reload.authenticate('new_password')).to be_truthy
        end
      end
    end
  end
end
