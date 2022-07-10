class Api::V1::OrdersController < Api::V1::V1Controller
  before_action :set_order, only: %w[show destroy charge]
  before_action :set_scope, only: %w[index]

  def index
    result = OrdersFetcher.new @scope

    render json: {
      results: OrderSerializer.render_as_hash(result.build(params)),
      meta: result.meta
    }
  end

  def show
    render json: OrderSerializer.render_as_hash(@order)
  end

  def create
    result = Orders::CreateService.perform params, current_user

    if result.success?
      render(
        status: 201,
        json: OrderSerializer.render_as_hash(result.data[:order])
      )
    else
      render_error 422, {status: result.status, message: result.message}
    end
  end

  def destroy
    result = Orders::CancelService.perform @order, current_user

    if result.success?
      render(
        status: 200,
        json: OrderSerializer.render_as_hash(result.data[:order])
      )
    else
      render_error 422, {status: result.status, message: result.message}
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def set_scope
    @scope = current_user.orders
  end
end
