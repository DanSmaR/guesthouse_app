class RoomRate < ApplicationRecord
  validates :daily_rate, :start_date, :end_date, presence: true
  validates :daily_rate, numericality: { greater_than: 0 }
  belongs_to :room
end
