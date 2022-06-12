class Notification < ApplicationRecord
  scope :latest_notice, -> { order(created_at: :desc) }
  belongs_to :concern, optional: true
  belongs_to :advice, optional: true
  belongs_to :recommend, optional: true
  belongs_to :visiter, class_name: 'User', optional: true
  belongs_to :visited, class_name: 'User', optional: true
end
