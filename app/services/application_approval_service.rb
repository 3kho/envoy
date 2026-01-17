class ApplicationApprovalService
  def initialize(application, admin)
    @application = application
    @admin = admin
  end

  def approve!(notes: nil)
    return { success: false, error: "Application cannot be approved" } unless @application.can_be_approved?

    ActiveRecord::Base.transaction do
      @application.approve!(@admin, notes: notes)

      ActivityLog.log!(
        trackable: @application,
        action: "approved",
        admin: @admin,
        metadata: { notes: notes }
      )

      GenerateAndSendLetterJob.perform_later(@application.id)
    end

    { success: true }
  rescue StandardError => e
    Rails.logger.error("Failed to approve application: #{e.message}")
    { success: false, error: e.message }
  end

  def reject!(reason:, notes: nil)
    return { success: false, error: "Application cannot be rejected" } unless @application.can_be_rejected?

    ActiveRecord::Base.transaction do
      @application.reject!(@admin, reason: reason, notes: notes)

      ActivityLog.log!(
        trackable: @application,
        action: "rejected",
        admin: @admin,
        metadata: { reason: reason, notes: notes }
      )

      SendRejectionNotificationJob.perform_later(@application.id)
    end

    { success: true }
  rescue StandardError => e
    Rails.logger.error("Failed to reject application: #{e.message}")
    { success: false, error: e.message }
  end
end
