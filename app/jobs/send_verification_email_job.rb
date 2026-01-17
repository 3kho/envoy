class SendVerificationEmailJob < ApplicationJob
  queue_as :default

  def perform(participant_id)
    participant = Participant.find_by(id: participant_id)
    return if participant.nil?
    return if participant.email_verified?

    ApplicationMailer.verification_code(participant).deliver_now
  end
end
