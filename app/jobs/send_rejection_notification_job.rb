class SendRejectionNotificationJob < ApplicationJob
  queue_as :default

  def perform(application_id)
    application = VisaLetterApplication.find_by(id: application_id)
    return if application.nil?
    return unless application.rejected?

    ApplicationMailer.application_rejected(application).deliver_now

    ActivityLog.log!(
      trackable: application,
      action: "rejection_notification_sent",
      metadata: { reference_number: application.reference_number }
    )
  end
end
