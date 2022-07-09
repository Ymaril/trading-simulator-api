module CrudServices
  class Save < Base
    def perform_chain
      ['save_object']
    end

    protected

    def save_object
      object.assign_attributes permitted_attributes
      if object.save
        success_result data: { object_name => object }
      else
        invalid_params_result object
      end
    end

    def object_params
      params
    end

    def permitted_params
      raise '`permitted_params` must be implemented in child class'
    end

    def prepare_params(raw_params)
      result = raw_params.deep_dup
      result = ActionController::Parameters.new(result) unless result.is_a?(ActionController::Parameters)
      result
    end
  end
end
