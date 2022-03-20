class Concern < ApplicationRecord
  with_options presence: true do
    validates :title
    validates :content
  end

  belongs_to :user
  mount_uploader :image, ImageUploader
end
