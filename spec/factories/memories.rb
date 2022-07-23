FactoryBot.define do
  factory :memory do
    title { "memoryのタイトル" }
    content { Faker::Lorem.characters(number: 300) }
    date  { Date.today }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg')) }
    association :user
  end

  factory :memory_1, class: "Memory" do
    title { Faker::Lorem.characters(number: 20) }
    content { Faker::Lorem.characters(number: 300) }
    date  { Date.today }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg')) }
    association :user
  end

  factory :memory_2, class: "Memory" do
    title { "今日の出来事" }
    content { "今日は1日楽しかった" }
    date  { "2022-11-11" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg')) }
    association :user
  end
end
