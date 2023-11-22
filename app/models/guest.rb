class Guest < ApplicationRecord
  belongs_to :user
  has_many :bookings
  has_one :review
end
