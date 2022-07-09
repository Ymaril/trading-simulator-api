module Orders
  class CreateService < ::CrudServices::CreateService
    def perform_chain
      %w[assign_user save_object]
    end

    private

    def assign_user
      if current_user.accounts.where(currency_id: params[:from_currency_id]).exists?
        object.user = current_user
        
        success_result
      else
        error_result message: 'User not have currency account'
      end
    end

    def permitted_attributes
      object_params.permit(:from_currency_id, :to_currency_id, :value, :expires_at, :complete_type)
    end

    def build_object
      Order.new
    end
  end
end
