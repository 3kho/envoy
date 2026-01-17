class GenerateAndSendLetterJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: :polynomially_longer, attempts: 3

  def perform(application_id)
    application = VisaLetterApplication.find_by(id: application_id)
    return if application.nil?
    return unless application.approved?
    return if application.letter_sent?

    pdf_content = PdfGeneratorService.new(application).generate
    return if pdf_content.nil?

    application.letter_pdf.attach(
      io: StringIO.new(pdf_content),
      filename: "visa_letter_#{application.reference_number}.pdf",
      content_type: "application/pdf"
    )

    application.mark_letter_generated!

    ApplicationMailer.visa_letter_approved(application).deliver_now

    application.mark_letter_sent!

    ActivityLog.log!(
      trackable: application,
      action: "letter_sent",
      metadata: { reference_number: application.reference_number }
    )
  end
end
