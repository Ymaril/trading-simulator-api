class Api::V1::Admin::CurrenciesController < Api::V1::Admin::AdminController
  before_action :set_currency, only: %w[show destroy]
  before_action :set_scope, only: %w[index]

  def index
    result = CurrenciesFetcher.new @scope

    render json: {
      results: CurrencySerializer.render_as_hash(result.build(params)),
      meta: result.meta
    }
  end

  def show
    render json: CurrencySerializer.render_as_hash(@currency)
  end

  def create
    result = Currencies::CreateService.perform params, current_user

    if result.success?
      render(
        status: 201,
        json: CurrencySerializer.render_as_hash(result.data[:currency])
      )
    else
      render_error 422, {status: result.status, message: result.message}
    end
  end

  def destroy
    result = Currencies::DestroyService.perform @currency, params, current_user

    if result.success?
      render(
        status: 200,
        json: CurrencySerializer.render_as_hash(result.data[:currency])
      )
    else
      render_error 422, {status: result.status, message: result.message}
    end
  end

  private

  def set_currency
    @currency = Currency.find(params[:id])
  end

  def set_scope
    @scope = Currency.all
  end
end
