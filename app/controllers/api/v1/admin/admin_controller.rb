class Api::V1::Admin::AdminController < Api::V1::V1Controller
  before_action :authorize_admin

  def authorize_admin
    unless current_user.admin?
      render_error(401, message: "You're not authorized to access this resource.")
    end
  end
end
