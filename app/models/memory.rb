class Memory < ApplicationRecord
  with_options presence: true do
    validates :title
    validates :content
    validates :date
  end
  validate :date_cannot_be_in_the_past

  def date_cannot_be_in_the_past
    if date < Date.today
      errors.add(:date, "今日より過去の日付の指定はできません。")
    end
  end
  belongs_to :user, optional: true
  mount_uploader :image, ImageUploader
end
