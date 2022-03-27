class Concern < ApplicationRecord
  with_options presence: true do
    validates :title
    validates :content
  end

  mount_uploader :image, ImageUploader

  belongs_to :user
  has_many :advices, dependent: :destroy

end
