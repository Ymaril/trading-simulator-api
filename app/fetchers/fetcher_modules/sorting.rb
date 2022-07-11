# frozen_string_literal: true

module FetcherModules
  module Sorting
    def sort(source)
      direction = (params[:order_by] || 'ASC').downcase.to_sym

      source.reorder(sort_field => direction)
    end

    def sort_field
      params[:sort_by] || default_sort_field
    end

    def default_sort_field
      'created_at'
    end
  end
end
