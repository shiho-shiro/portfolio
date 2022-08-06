FactoryBot.define do
  factory :concern do
    title { "お悩みのタイトル" }
    content { Faker::Lorem.characters(number: 200) }
    country_code { Faker::Address.country_code }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg')) }
    association :user
  end

  factory :another_concern, class: "Concern" do
    title { "どうすれば..." }
    content { Faker::Lorem.characters(number: 200) }
    country_code { "JP" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/no_image.jpg')) }
    association :user
  end

  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end
end
