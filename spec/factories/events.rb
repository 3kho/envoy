FactoryBot.define do
  factory :event do
    sequence(:name) { |n| "Hack Event #{n}" }
    sequence(:slug) { |n| "hack-event-#{n}" }
    description { Faker::Lorem.paragraph }
    venue_name { "Convention Center" }
    venue_address { Faker::Address.street_address }
    city { Faker::Address.city }
    country { Countries::LIST.sample }
    start_date { 3.months.from_now.to_date }
    end_date { 3.months.from_now.to_date + 2.days }
    contact_email { Faker::Internet.email }
    active { true }
    applications_open { true }
    association :admin

    trait :past do
      start_date { 2.months.ago.to_date }
      end_date { 2.months.ago.to_date + 2.days }
      active { false }
      applications_open { false }
    end

    trait :closed do
      applications_open { false }
    end

    trait :with_deadline do
      application_deadline { 2.months.from_now }
    end

    trait :deadline_passed do
      application_deadline { 1.week.ago }
    end
  end
end
