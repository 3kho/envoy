class ApplicationController < ActionController::Base
  include Pundit::Authorization

  allow_browser versions: :modern

  def pundit_user
    current_admin
  end
end
