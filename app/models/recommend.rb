class Recommend < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  mount_uploader :image, ImageUploader
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  with_options presence: true do
    validates :title
    validates :content
    validates :country_code
    validates :address
  end
  validates :title, {length: {maximum: 20}}

  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end

  def create_notification_like!(current_user)
    temp = Notification.where(["visiter_id = ? and visited_id = ? and recommend_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        recommend_id: id,
        visited_id: user_id,
        action: 'like'
      )
      if notification.visiter_id == notification.visited_id
        notification.checked = true
      end

      notification.save if notification.valid?
    end
  end
end
