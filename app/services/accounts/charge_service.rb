module Accounts
  class ChargeService < ::CrudServices::Save
    def initialize(object, params, current_user = nil)
      @object = object
      @params = prepare_params params
      @current_user = current_user
    end

    def perform_chain
      %w[validate_value save_object]
    end

    private

    def validate_value
      if params[:value].to_i.positive?
        success_result
      else
        error_result message: 'Invalid value'
      end
    end

    def save_object
      object.assign_attributes(balance: new_balance)
      if object.save
        success_result data: { object_name => object }
      else
        invalid_params_result object
      end
    end
    
    def new_balance
      object.balance + params[:value].to_i
    end
  end
end
