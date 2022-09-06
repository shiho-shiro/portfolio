class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true
  validates :country_code, presence: true
  validates :username, { length: { maximum: 10 } }

  has_many :memories, dependent: :destroy
  has_many :concerns, dependent: :destroy
  has_many :advices, dependent: :destroy
  has_many :recommends, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :active_notifications, class_name: "Notification", foreign_key: "visiter_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end

  def already_likes?(recommend)
    likes.exists?(recommend_id: recommend.id)
  end

  def self.guest
    find_or_create_by(email: 'guest_user@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.username = "ゲスト"
    end
  end

  has_one_attached :image
end
