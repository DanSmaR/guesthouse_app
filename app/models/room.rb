class Room < ApplicationRecord
  validates :name, :description, :size, :max_people, :daily_rate, presence: true
  validates :size, :max_people, numericality: { greater_than: 0 }
  validates :daily_rate, numericality: { greater_than: 0, less_than: 100_000 }
  validates :bathroom, :balcony, :air_conditioning, :tv, :wardrobe, :safe,
            :accessible, :available, inclusion: { in: [true, false] }
  belongs_to :guesthouse
  has_many :room_rates, dependent: :destroy, inverse_of: :room
  has_many :bookings, dependent: :destroy
end
