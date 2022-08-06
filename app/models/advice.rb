class Advice < ApplicationRecord
  belongs_to :user
  belongs_to :concern
  has_many :notifications, dependent: :destroy

  validates :advice, presence: true
  validates :advice, { length: { maximum: 100 } }
end
