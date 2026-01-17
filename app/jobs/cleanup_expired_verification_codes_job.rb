class CleanupExpiredVerificationCodesJob < ApplicationJob
  queue_as :low

  def perform
    Participant
      .where.not(verification_code: nil)
      .where("verification_code_sent_at < ?", Participant::VERIFICATION_CODE_EXPIRY.ago)
      .update_all(verification_code: nil, verification_code_sent_at: nil)
  end
end
