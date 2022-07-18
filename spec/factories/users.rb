FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    sequence(:email) { |n| "test#{n}@example.com" }
    sequence(:password) { |n| "test_#{n}" }
    password_confirmation { password }
    country_code { Faker::Address.country_code }
    job { Faker::Job.title }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg')) }
  end

  factory :another_user, class: "User" do
    username { Faker::Name.name }
    sequence(:email) { |n| "test_another#{n}@example.com" }
    sequence(:password) { |n| "test_another#{n}" }
    password_confirmation { password }
    country_code { Faker::Address.country_code }
    job { Faker::Job.title }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg')) }
  end

  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end
end
