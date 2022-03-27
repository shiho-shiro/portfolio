class Advice < ApplicationRecord
  validates :advice, presence: true

  belongs_to :user
  belongs_to :concern
end
