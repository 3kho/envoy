FactoryBot.define do
  factory :activity_log do
    association :trackable, factory: :visa_letter_application
    action { "application_created" }
    metadata { {} }
    association :admin
  end
end
