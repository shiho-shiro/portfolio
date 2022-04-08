class Concern < ApplicationRecord
  with_options presence: true do
    validates :title
    validates :content
    validates :country_code
  end

  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end

  mount_uploader :image, ImageUploader

  belongs_to :user
  has_many :advices, dependent: :destroy

end
