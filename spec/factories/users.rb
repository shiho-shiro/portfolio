FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    email { Faker::Internet.free_email }
    password { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
    country_code { Faker::Address.country }
    job { Faker::Job.title }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg')) }
  end
end
