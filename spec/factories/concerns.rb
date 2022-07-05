FactoryBot.define do
  factory :concern do
    title { "お悩みのタイトル" }
    content { Faker::Lorem.characters(number: 200) }
    country_code { Faker::Address.country }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg')) }
    association :user
  end
end
