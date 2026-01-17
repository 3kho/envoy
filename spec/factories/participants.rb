FactoryBot.define do
  factory :participant do
    sequence(:email) { |n| "participant#{n}@example.com" }
    full_name { Faker::Name.name }
    date_of_birth { 16.years.ago.to_date }
    country_of_birth { Countries::LIST.sample }
    phone_number { Faker::PhoneNumber.phone_number }
    full_street_address { "#{Faker::Address.street_address}, #{Faker::Address.city}, #{Faker::Address.zip_code}" }
    verification_attempts { 0 }

    trait :verified do
      email_verified_at { 1.day.ago }
    end

    trait :with_verification_code do
      verification_code { "123456" }
      verification_code_sent_at { 5.minutes.ago }
    end

    trait :expired_code do
      verification_code { "123456" }
      verification_code_sent_at { 35.minutes.ago }
    end
  end
end
