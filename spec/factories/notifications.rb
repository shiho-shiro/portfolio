FactoryBot.define do
  factory :notification do
    association :visiter, factory: :user
    association :visited, factory: :aother_user
    association :recommend
    association :concern
    association :advice
    checked { true }
  end
end
