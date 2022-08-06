FactoryBot.define do
  factory :notification do
    association :visiter, factory: :user
    association :visited, factory: :another_user
    association :recommend
    association :concern
    association :advice
    checked { false }
  end
end
