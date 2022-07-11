# frozen_string_literal: true

module Orders
  class CancelService < ::CrudServices::Save
    def initialize(object, current_user = nil)
      @object = object
      @current_user = current_user
    end

    private

    def save_object
      object.cancel

      if object.save
        success_result data: { object_name => object }
      else
        invalid_params_result object
      end
    end
  end
end
