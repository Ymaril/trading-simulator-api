# frozen_string_literal: true

module FetcherModules
  module Pagination
    attr_reader :total

    def meta
      return { total_count: total } if params[:page].nil? || params[:per_page].nil?

      limit_count = params[:per_page].to_i
      last_page = limit_count.positive? ? (total.to_f / limit_count).ceil : 1

      {
        current_page: params[:page].to_i,
        total_pages: last_page,
        per_page: limit_count,
        total_count: total
      }
    end

    def paginate(source)
      @total = source.size
      offset limit(source)
    end

    def offset(source)
      result = source

      offset = params[:page].to_i.positive? ? (params[:page].to_i - 1) * params[:per_page].to_i : 0

      result = result.offset(offset) if offset

      result
    end

    def limit(source)
      limit = params[:per_page] || params[:limit]
      result = source

      result = result.limit(limit) if limit

      result
    end
  end
end
