FactoryBot.define do
  factory :admin do
    sequence(:email) { |n| "admin#{n}@hackclub.com" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { "password123" }
    password_confirmation { "password123" }
    super_admin { false }

    trait :super_admin do
      super_admin { true }
    end
  end
end
