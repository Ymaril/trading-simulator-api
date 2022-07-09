module FetcherModules
  module Filtering
    def filter_types
      [
        {
          name: 'greater_than',
          value: -> (params) { !params.is_a?(String) && params[:gte] }
        },
        {
          name: 'lesser_than',
          value: -> (params) { !params.is_a?(String) && params[:lte] }
        },
        {
          name: 'equal',
          value: -> (params) { params.is_a?(String) && params }
        }
      ]
    end

    def filter(source)
      result = source

      filters.each do |attribute_name|
        next unless params[attribute_name].present?

        filter_types.each do |filter|
          values = filter[:value].call params[attribute_name]

          if values.is_a? String
            method_name = "#{attribute_name}_#{filter[:name]}"

            if respond_to?(method_name)
              result = send(method_name, values, result)
            elsif model_attributes.include?(attribute_name)
              result = send("filter_#{filter[:name]}_by", attribute_name, values, result)
            end
          end
        end
      end

      result
    end

    def filter_greater_than_by(attribute_name, values, source)
      source.where(attribute_name => values..)
    end

    def filter_lesser_than_by(attribute_name, values, source)
      source.where(attribute_name => ..values)
    end

    def filter_equal_by(attribute_name, values, source)
      source.where(attribute_name => values.split(','))
    end

    def filters
      model_attributes + custom_filters
    end

    def custom_filters
      []
    end

    def model_attributes
      scope_klass.attribute_names
    end
  end
end