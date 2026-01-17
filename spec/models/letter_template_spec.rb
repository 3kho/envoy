require "rails_helper"

RSpec.describe LetterTemplate, type: :model do
  describe "validations" do
    subject { build(:letter_template) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:signatory_name) }
    it { should validate_presence_of(:signatory_title) }
    it { should validate_length_of(:body).is_at_least(100) }

    it "allows only one default template for global templates" do
      create(:letter_template, :default, event: nil)
      duplicate = build(:letter_template, :default, event: nil)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:is_default]).to be_present
    end

    it "allows event-specific templates with is_default false when global default exists" do
      create(:letter_template, :default, event: nil)
      event_template = build(:letter_template, :for_event, is_default: false)
      expect(event_template).to be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:event).optional }
    it { should have_one_attached(:signature_image) }
    it { should have_one_attached(:letterhead_image) }
  end

  describe ".default_template" do
    it "returns the global default template" do
      default = create(:letter_template, :default, event: nil, active: true)
      create(:letter_template, event: nil, is_default: false)

      expect(LetterTemplate.default_template).to eq(default)
    end

    it "returns nil if no default exists" do
      expect(LetterTemplate.default_template).to be_nil
    end
  end

  describe "#render" do
    let(:participant) { create(:participant, full_name: "Alice Johnson", email: "alice@example.com") }
    let(:event) { create(:event, name: "Assemble 2026") }
    let(:application) { create(:visa_letter_application, participant: participant, event: event) }
    let(:template) do
      long_body = "Dear {{participant_full_name}}, Welcome to {{event_name}}. Ref: {{reference_number}}. " * 10
      create(:letter_template, body: long_body)
    end

    it "replaces all placeholders with actual values" do
      result = template.render(application)

      expect(result).to include("Alice Johnson")
      expect(result).to include("Assemble 2026")
      expect(result).to include(application.reference_number)
    end
  end
end
