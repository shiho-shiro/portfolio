class Advice < ApplicationRecord
  belongs_to :user
  belongs_to :concern
  has_many :notifications, dependent: :destroy
end
