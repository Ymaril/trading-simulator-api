class BaseFetcher
  include FetcherModules::Pagination
  include FetcherModules::Filtering
  include FetcherModules::Sorting

  attr_reader :scope, :params

  def initialize(scope)
    @scope = scope
  end

  def build(params)
    @params = params.try(:with_indifferent_access) || params

    method_names.reduce(scope) do |result, method_name|
      send(method_name, result)
    end
  end

  def method_names
    %w[filter paginate sort after_fetch]
  end

  def after_fetch(source)
    source
  end

  def scope_klass
    scope.klass
  end
end