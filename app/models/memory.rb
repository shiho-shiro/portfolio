class Memory < ApplicationRecord
  with_options presence: true do
    validates :title
    validates :content
    validates :date
  end
  validates :title, { length: { maximum: 20 } }
  validates :content, { length: { maximum: 300 } }

  belongs_to :user
  mount_uploader :image, ImageUploader
end
