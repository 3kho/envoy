FactoryBot.define do
  factory :letter_template do
    sequence(:name) { |n| "Template #{n}" }
    body { "Dear {{participant_full_name}},\n\nThis is to confirm your invitation to {{event_name}}.\n\n" * 5 }
    signatory_name { "Jane Doe" }
    signatory_title { "Executive Director" }
    event { nil }
    is_default { false }
    active { true }

    trait :default do
      is_default { true }
    end

    trait :for_event do
      association :event
    end

    trait :inactive do
      active { false }
    end
  end
end
