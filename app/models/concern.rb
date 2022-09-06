class Concern < ApplicationRecord
  belongs_to :user
  has_many :advices, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_one_attached :image

  with_options presence: true do
    validates :title
    validates :content
    validates :country_code
  end

  validates :title, { length: { maximum: 20 } }
  validates :content, { length: { maximum: 200 } }

  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end

  def create_notification_advice!(current_user, advice_id)
    temp_ids = Advice.select(:user_id).where(concern_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_advice!(current_user, advice_id, temp_id['user_id'])
    end

    save_notification_advice!(current_user, advice_id, user_id) if temp_ids.blank?
  end

  def save_notification_advice!(current_user, advice_id, visited_id)
    notification = current_user.active_notifications.new(
      concern_id: id,
      advice_id: advice_id,
      visited_id: visited_id,
      action: 'advice'
    )
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end

    notification.save if notification.valid?
  end
end
