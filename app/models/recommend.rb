class Recommend < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  mount_uploader :image, ImageUploader
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  with_options presence: true do
    validates :title
    validates :content
    validates :country_code
    validates :address
  end

  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end
end
