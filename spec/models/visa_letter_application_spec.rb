require "rails_helper"

RSpec.describe VisaLetterApplication, type: :model do
  describe "validations" do
    subject { build(:visa_letter_application) }

    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(VisaLetterApplication::STATUSES) }
    # reference_number is auto-generated before validation, so we test it differently
    it "generates reference_number automatically" do
      application = build(:visa_letter_application, reference_number: nil)
      application.valid?
      expect(application.reference_number).to be_present
    end

    it "validates uniqueness of participant per event" do
      existing = create(:visa_letter_application)
      duplicate = build(:visa_letter_application, participant: existing.participant, event: existing.event)
      expect(duplicate).not_to be_valid
    end

    it "requires rejection_reason when status is rejected" do
      application = build(:visa_letter_application, status: "rejected", rejection_reason: nil)
      expect(application).not_to be_valid
      expect(application.errors[:rejection_reason]).to be_present
    end
  end

  describe "associations" do
    it { should belong_to(:participant) }
    it { should belong_to(:event) }
    it { should belong_to(:reviewed_by).class_name("Admin").optional }
    it { should have_one_attached(:letter_pdf) }
  end

  describe "reference number generation" do
    it "auto-generates reference number on create" do
      application = create(:visa_letter_application)
      expect(application.reference_number).to match(/\AHC-[A-Z0-9]{8}\z/)
    end

    it "generates unique reference numbers" do
      refs = 10.times.map { create(:visa_letter_application).reference_number }
      expect(refs.uniq.length).to eq(10)
    end
  end

  describe "#mark_as_submitted!" do
    it "updates status to pending_approval and sets submitted_at" do
      application = create(:visa_letter_application)
      application.mark_as_submitted!

      expect(application.status).to eq("pending_approval")
      expect(application.submitted_at).to be_present
    end
  end

  describe "#approve!" do
    let(:admin) { create(:admin) }
    let(:application) { create(:visa_letter_application, :pending_approval) }

    it "updates status to approved" do
      result = application.approve!(admin, notes: "Looks good")
      expect(result).to be true
      expect(application.status).to eq("approved")
      expect(application.reviewed_by).to eq(admin)
      expect(application.reviewed_at).to be_present
      expect(application.admin_notes).to eq("Looks good")
    end

    it "returns false if not pending_approval" do
      application.update!(status: "approved")
      result = application.approve!(admin)
      expect(result).to be false
    end
  end

  describe "#reject!" do
    let(:admin) { create(:admin) }
    let(:application) { create(:visa_letter_application, :pending_approval) }

    it "updates status to rejected with reason" do
      result = application.reject!(admin, reason: "Missing documents", notes: "Please resubmit")
      expect(result).to be true
      expect(application.status).to eq("rejected")
      expect(application.rejection_reason).to eq("Missing documents")
      expect(application.admin_notes).to eq("Please resubmit")
    end

    it "returns false if not pending_approval" do
      application.update!(status: "approved")
      result = application.reject!(admin, reason: "Test")
      expect(result).to be false
    end
  end

  describe "scopes" do
    it "filters by status" do
      pending = create(:visa_letter_application, :pending_approval)
      approved = create(:visa_letter_application, :approved)

      expect(VisaLetterApplication.pending_approval).to include(pending)
      expect(VisaLetterApplication.pending_approval).not_to include(approved)
      expect(VisaLetterApplication.approved).to include(approved)
    end
  end
end
