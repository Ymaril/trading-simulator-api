Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  scope path: 'api/v1' do
    api_guard_routes for: 'users'
  end
end
