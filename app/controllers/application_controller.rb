class ApplicationController < ActionController::API
  def route_not_found
    render json: {"error": 'not_found'}, status: :not_found
  end
end
