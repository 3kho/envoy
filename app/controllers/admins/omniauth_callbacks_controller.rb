class Admins::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :hack_club

  def hack_club
    @admin = Admin.from_omniauth(request.env["omniauth.auth"])

    if @admin
      sign_in_and_redirect @admin, event: :authentication
      set_flash_message(:notice, :success, kind: "Hack Club") if is_navigational_format?
    else
      redirect_to root_path, alert: "You are not authorized to access the admin area."
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to root_path, alert: "Authentication failed: #{e.message}"
  end

  def failure
    redirect_to root_path, alert: "Authentication failed. Please try again."
  end
end
