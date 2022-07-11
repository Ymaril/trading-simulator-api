# frozen_string_literal: true

module Api
  module V1
    class AccountsController < Api::V1::V1Controller
      before_action :set_account, only: %w[show destroy charge]
      before_action :set_scope, only: %w[index]

      def index
        result = AccountsFetcher.new @scope

        render json: {
          results: AccountSerializer.render_as_hash(result.build(params)),
          meta: result.meta
        }
      end

      def show
        render json: AccountSerializer.render_as_hash(@account)
      end

      def create
        result = Accounts::CreateService.perform params, current_user

        if result.success?
          render(
            status: 201,
            json: AccountSerializer.render_as_hash(result.data[:account])
          )
        else
          render_error 422, { status: result.status, message: result.message }
        end
      end

      def destroy
        result = Accounts::DestroyService.perform @account, params, current_user

        if result.success?
          render(
            status: 200,
            json: AccountSerializer.render_as_hash(result.data[:account])
          )
        else
          render_error 422, { status: result.status, message: result.message }
        end
      end

      def charge
        result = Accounts::ChargeService.perform @account, params, current_user

        if result.success?
          render(
            status: 200,
            json: AccountSerializer.render_as_hash(result.data[:account])
          )
        else
          render_error 422, { status: result.status, message: result.message }
        end
      end

      private

      def set_account
        @account = current_user.accounts.find(params[:id])
      end

      def set_scope
        @scope = current_user.accounts
      end
    end
  end
end
