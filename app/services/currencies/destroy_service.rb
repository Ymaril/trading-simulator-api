module Currencies
  class DestroyService < ::CrudServices::DestroyService
    def perform_chain
      %w[check_usage destroy_object]
    end

    private

    def check_usage
      if object.accounts.present?
        error_result message: 'Currency in use'
      else
        success_result
      end
    end
  end
end
