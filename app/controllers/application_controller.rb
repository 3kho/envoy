class ApplicationController < ActionController::Base
  include Pundit::Authorization

  allow_browser versions: :modern

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def pundit_user
    current_admin
  end

  private

  def render_not_found
    render file: Rails.public_path.join("404.html"), status: :not_found, layout: false
  end
end
