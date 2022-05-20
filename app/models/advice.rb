class Advice < ApplicationRecord
  belongs_to :user
  belongs_to :concern
  has_many :notifications, dependent: :destroy

  validates :advice, {length: {maximum: 200}}
end
