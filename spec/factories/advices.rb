FactoryBot.define do
  factory :advice do
    advice { Faker::Lorem.characters(number: 100) }
    association :concern
    user {concern.user}
  end
end
