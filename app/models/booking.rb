class Booking < ApplicationRecord
  validates :check_in_date, :check_out_date, :number_of_guests, presence: true
  belongs_to :room
end
