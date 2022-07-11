# frozen_string_literal: true

module Api
  module V1
    module Admin
      class AdminController < Api::V1::V1Controller
        before_action :authorize_admin

        def authorize_admin
          render_error(401, message: "You're not authorized to access this resource.") unless current_user.admin?
        end
      end
    end
  end
end
