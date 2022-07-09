module CrudServices
  class DestroyService < Base
    def initialize(object, params = {}, current_user = nil, options = {})
      @object = object
      @params = params
      @current_user = current_user
      @options = options
    end

    def perform_chain
      ['destroy_object']
    end

    protected

    def destroy_object
      if object.destroy
        success_result data: { object_name => object }
      else
        invalid_params_result object
      end
    end
  end
end