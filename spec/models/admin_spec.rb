require "rails_helper"

RSpec.describe Admin, type: :model do
  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_length_of(:first_name).is_at_most(100) }
    it { should validate_length_of(:last_name).is_at_most(100) }
  end

  describe "associations" do
    it { should have_many(:events).dependent(:restrict_with_error) }
    it { should have_many(:reviewed_applications).class_name("VisaLetterApplication") }
    it { should have_many(:activity_logs).dependent(:nullify) }
  end

  describe "#full_name" do
    it "returns the combined first and last name" do
      admin = build(:admin, first_name: "John", last_name: "Doe")
      expect(admin.full_name).to eq("John Doe")
    end
  end
end
