class Memory < ApplicationRecord
  with_options presence: true do
    validates :title
    validates :content
    validates :date
  end

  belongs_to :user, optional: true
  mount_uploader :image, ImageUploader
end
