Rails.application.routes.draw do
  scope path: 'api/v1' do
    api_guard_routes for: 'users'
  end
end
