FactoryBot.define do
  factory :recommend do
    title { "オススメのタイトル" }
    content { Faker::Lorem.characters(number: 200) }
    country_code { Faker::Address.country_code }
    address { Faker::Address.full_address }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg')) }
    association :user
  end

  factory :recommend_1, class: "Recommend" do
    title { "今日の出来事" }
    content { Faker::Lorem.characters(number: 200) }
    country_code { "JP" }
    address { Faker::Address.full_address }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg')) }
    association :user
  end

  factory :recommend_2, class: "Recommend" do
    title { "ここがオススメ" }
    content { Faker::Lorem.characters(number: 200) }
    country_code { "JP" }
    address { Faker::Address.full_address }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/aurora.jpg')) }
    association :user
  end

  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end
end
