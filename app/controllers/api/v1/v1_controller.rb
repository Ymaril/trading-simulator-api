class Api::V1::V1Controller < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    render json: {"error": 'not_found'}, status: :not_found
  end
end
