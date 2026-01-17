class Admin::DashboardController < Admin::BaseController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    @pending_count = policy_scope(VisaLetterApplication).pending_approval.count
    @recent_applications = policy_scope(VisaLetterApplication).order(created_at: :desc).limit(10)
    @upcoming_events = policy_scope(Event).upcoming.order(:start_date).limit(5)
    @stats = {
      total_applications: policy_scope(VisaLetterApplication).count,
      pending: policy_scope(VisaLetterApplication).pending_approval.count,
      approved: policy_scope(VisaLetterApplication).approved.count + policy_scope(VisaLetterApplication).letter_sent.count,
      rejected: policy_scope(VisaLetterApplication).rejected.count
    }
  end
end
