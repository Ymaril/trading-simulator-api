# frozen_string_literal: true

module Currencies
  class CreateService < ::CrudServices::CreateService
    private

    def permitted_attributes
      object_params.permit(:name, :code)
    end

    def build_object
      Currency.new
    end
  end
end
