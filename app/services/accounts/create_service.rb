# frozen_string_literal: true

module Accounts
  class CreateService < ::CrudServices::CreateService
    def perform_chain
      %w[assign_current_user save_object]
    end

    private

    def assign_current_user
      if current_user.present?
        object.user = current_user

        success_result
      else
        error_result message: 'Current user must exist'
      end
    end

    def permitted_attributes
      object_params.permit(:currency_id)
    end

    def build_object
      Account.new
    end
  end
end
