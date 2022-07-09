Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  scope path: 'api/v1' do
    api_guard_routes for: 'users'
  end

  namespace :api do
    namespace :v1 do
      namespace :admin do
        resources :currencies, except: %w[update]
      end
    end
  end

  match '*unmatched', to: 'application#route_not_found', via: :all
end
