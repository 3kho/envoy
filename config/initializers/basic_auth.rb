if ENV["BASIC_AUTH_ENABLED"] == "true"
  Rails.application.config.middleware.use Rack::Auth::Basic, "Protected Area" do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(username, ENV.fetch("BASIC_AUTH_USER", "admin")) &
    ActiveSupport::SecurityUtils.secure_compare(password, ENV.fetch("BASIC_AUTH_PASSWORD", ""))
  end
end
