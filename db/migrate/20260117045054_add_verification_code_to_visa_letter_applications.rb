class AddVerificationCodeToVisaLetterApplications < ActiveRecord::Migration[7.2]
  def change
    add_column :visa_letter_applications, :verification_code, :string
    add_index :visa_letter_applications, :verification_code, unique: true
  end
end
