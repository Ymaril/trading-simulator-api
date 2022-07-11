# frozen_string_literal: true

shared_context 'auth' do
  let(:jwt_payload) do
    {
      user_id: current_user.id,
      exp: (Time.now.utc + 10.minutes).to_i,
      iat: Time.now.utc.to_i
    }
  end
  let(:api_key) do
    Class.new { include ApiGuard::JwtAuth::JsonWebToken }.new.encode(jwt_payload)
  end
  let(:Authorization) { "Bearer #{api_key}" }
end
