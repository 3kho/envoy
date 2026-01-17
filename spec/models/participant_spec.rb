require "rails_helper"

RSpec.describe Participant, type: :model do
  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:date_of_birth) }
    it { should validate_presence_of(:country_of_birth) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_presence_of(:full_street_address) }

    it { should validate_length_of(:full_name).is_at_least(2).is_at_most(200) }
    it { should validate_length_of(:full_street_address).is_at_least(10) }

    it "validates minimum age of 13" do
      participant = build(:participant, date_of_birth: 10.years.ago)
      expect(participant).not_to be_valid
      expect(participant.errors[:date_of_birth]).to include("must be at least 13 years old")
    end
  end

  describe "associations" do
    it { should have_many(:visa_letter_applications).dependent(:destroy) }
    it { should have_many(:events).through(:visa_letter_applications) }
  end

  describe "email normalization" do
    it "normalizes email to lowercase" do
      participant = create(:participant, email: "TEST@Example.COM")
      expect(participant.email).to eq("test@example.com")
    end

    it "strips whitespace from email" do
      participant = create(:participant, email: "  test@example.com  ")
      expect(participant.email).to eq("test@example.com")
    end
  end

  describe "#email_verified?" do
    it "returns true when email_verified_at is present" do
      participant = build(:participant, email_verified_at: Time.current)
      expect(participant.email_verified?).to be true
    end

    it "returns false when email_verified_at is nil" do
      participant = build(:participant, email_verified_at: nil)
      expect(participant.email_verified?).to be false
    end
  end

  describe "#generate_verification_code!" do
    it "generates a 6-digit code" do
      participant = create(:participant)
      participant.generate_verification_code!

      expect(participant.verification_code).to match(/\A\d{6}\z/)
      expect(participant.verification_code_sent_at).to be_present
      expect(participant.verification_attempts).to eq(0)
    end
  end

  describe "#verify_code!" do
    let(:participant) { create(:participant, :with_verification_code) }

    it "returns true and verifies email with correct code" do
      result = participant.verify_code!("123456")
      expect(result).to be true
      expect(participant.email_verified_at).to be_present
      expect(participant.verification_code).to be_nil
    end

    it "returns false with incorrect code" do
      result = participant.verify_code!("000000")
      expect(result).to be false
      expect(participant.email_verified_at).to be_nil
    end

    it "increments verification_attempts on failure" do
      participant.verify_code!("000000")
      expect(participant.reload.verification_attempts).to eq(1)
    end

    it "returns false when code is expired" do
      participant = create(:participant, :expired_code)
      result = participant.verify_code!("123456")
      expect(result).to be false
    end

    it "returns false when max attempts exceeded" do
      participant.update!(verification_attempts: 5)
      result = participant.verify_code!("123456")
      expect(result).to be false
    end
  end

  describe "#verification_code_expired?" do
    it "returns true when code was sent more than 30 minutes ago" do
      participant = build(:participant, verification_code_sent_at: 35.minutes.ago)
      expect(participant.verification_code_expired?).to be true
    end

    it "returns false when code was sent within 30 minutes" do
      participant = build(:participant, verification_code_sent_at: 5.minutes.ago)
      expect(participant.verification_code_expired?).to be false
    end
  end

  describe "#can_resend_verification_code?" do
    it "returns true when no code was sent yet" do
      participant = build(:participant, verification_code_sent_at: nil)
      expect(participant.can_resend_verification_code?).to be true
    end

    it "returns true when last code was sent more than 2 minutes ago" do
      participant = build(:participant, verification_code_sent_at: 3.minutes.ago)
      expect(participant.can_resend_verification_code?).to be true
    end

    it "returns false when last code was sent within 2 minutes" do
      participant = build(:participant, verification_code_sent_at: 1.minute.ago)
      expect(participant.can_resend_verification_code?).to be false
    end
  end
end
