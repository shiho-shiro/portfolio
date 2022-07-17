FactoryBot.define do
  factory :recommend do
    title { "オススメのタイトル" }
    content { Faker::Lorem.characters(number: 200) }
    country_code { Faker::Address.country_code }
    address { Faker::Address.full_address }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg')) }
    association :user
  end

  factory :another_recommend, class: "Recommend" do
    title { "今日の出来事" }
    content { Faker::Lorem.characters(number: 200) }
    country_code { "JP" }
    address { Faker::Address.full_address }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg')) }
    association :user
  end
end
