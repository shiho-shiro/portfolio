class Memory < ApplicationRecord
  with_options presence: true do
    validates :title
    validates :content
    validates :date
  end
  validates :title, {length: {maximum: 20}}
  validates :content, {length: {maximum: 300}}
  validate :date_cannot_be_in_the_past, on: :create

  def date_cannot_be_in_the_past
    if date < Date.today
      errors.add(:date, "今日より過去の日付の指定はできません。")
    end
  end

  belongs_to :user
  mount_uploader :image, ImageUploader
end
