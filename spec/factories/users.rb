FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    sequence(:email) { |n| "test#{n}@example.com" }
    sequence(:password) { |n| "test_#{n}" }
    password_confirmation { password }
    country_code { Faker::Address.country }
    job { Faker::Job.title }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg')) }
  end
end
