class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  layout "admin"

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: admin_dashboard_path)
  end
end
