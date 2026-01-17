class RegenerateAndSendLetterJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: :polynomially_longer, attempts: 3

  def perform(application_id, admin_id = nil)
    application = VisaLetterApplication.find_by(id: application_id)
    return if application.nil?
    return unless application.approved? || application.letter_sent?

    pdf_content = PdfGeneratorService.new(application).generate
    return if pdf_content.nil?

    application.letter_pdf.purge if application.letter_pdf.attached?

    application.letter_pdf.attach(
      io: StringIO.new(pdf_content),
      filename: "visa_letter_#{application.reference_number}.pdf",
      content_type: "application/pdf"
    )

    application.update!(letter_generated_at: Time.current)

    ApplicationMailer.visa_letter_approved(application).deliver_now

    application.update!(letter_sent_at: Time.current, status: "letter_sent")

    admin = Admin.find_by(id: admin_id)

    ActivityLog.log!(
      trackable: application,
      admin: admin,
      action: "letter_regenerated_and_sent",
      metadata: { reference_number: application.reference_number }
    )
  end
end
