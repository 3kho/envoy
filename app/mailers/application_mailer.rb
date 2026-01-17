class ApplicationMailer < ActionMailer::Base
  default from: -> { ENV.fetch("MAIL_FROM_ADDRESS", "noreply@hackclub.com") }
  layout "mailer"

  def verification_code(participant)
    @participant = participant
    @code = participant.verification_code

    mail(
      to: participant.email,
      subject: "Your Hack Club Visa Letter Verification Code"
    )
  end

  def application_submitted(application)
    @application = application
    @participant = application.participant
    @event = application.event

    mail(
      to: @participant.email,
      subject: "Your Visa Letter Application Has Been Submitted - #{@event.name}"
    )
  end

  def visa_letter_approved(application)
    @application = application
    @participant = application.participant
    @event = application.event

    if application.letter_pdf.attached?
      attachments["visa_letter_#{application.reference_number}.pdf"] = application.letter_pdf.download
    end

    mail(
      to: @participant.email,
      subject: "Your Visa Letter is Ready - #{@event.name}"
    )
  end

  def application_rejected(application)
    @application = application
    @participant = application.participant
    @event = application.event

    mail(
      to: @participant.email,
      subject: "Update on Your Visa Letter Application - #{@event.name}"
    )
  end
end

