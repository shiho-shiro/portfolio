FactoryBot.define do
  factory :memory do
    title { Faker::Lorem.characters(number: 20) }
    content { Faker::Lorem.characters(number: 300) }
    date  { Date.today }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg')) }
    association :user
  end
end
