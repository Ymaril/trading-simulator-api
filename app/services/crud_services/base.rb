# frozen_string_literal: true

module CrudServices
  class Base
    include ServiceResultMethods

    attr_reader :object, :params, :current_user, :options

    def self.perform(*args)
      new(*args).perform
    end

    def perform
      result = nil
      ActiveRecord::Base.transaction do
        perform_chain.each do |method|
          result = send method
          raise ActiveRecord::Rollback if result.failure?
        end
      end
      return result unless result.success?

      success_result data: { object_name => object }
    end

    def perform_chain
      raise '`perform_chain` must be implemented in child class'
    end

    protected

    def object_name
      object.model_name.to_s.underscore.to_sym
    end

    def method_missing(method, *args)
      object_name == method ? object : super
    end
  end
end
