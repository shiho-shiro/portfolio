FactoryBot.define do
  factory :like do
    association :recommend
    user { recommend.user }
  end
end
