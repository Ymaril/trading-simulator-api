module CrudServices
  class CreateService < Save
    def initialize(params, current_user = nil, options = {})
      @object = build_object
      @params = prepare_params params
      @current_user = current_user
      @options = options
    end

    protected

    def build_object
      raise '`build_object` must be implemented in child class'
    end
  end
end
