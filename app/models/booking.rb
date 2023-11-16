class Booking < ApplicationRecord
  validates :check_in_date, :check_out_date, :number_of_guests, presence: true
  belongs_to :room
  belongs_to :guest

  def check_availability
    room_availability
    room_capacity
    errors.empty?
  end

  def required_fields
    empty_field_error_message = "Não pode estar em branco"
    errors.add(:check_in_date, empty_field_error_message) if check_in_date.blank?
    errors.add(:check_out_date, empty_field_error_message) if check_out_date.blank?
    errors.add(:number_of_guests, empty_field_error_message) if number_of_guests.blank?
    errors.empty?
  end

  def total_price
    total = 0
    (check_in_date...check_out_date).each do |date|
      rate = room.room_rates.where('start_date <= ? AND end_date >= ?', date, date).first
      total += rate ? rate.daily_rate : room.daily_rate
    end
    total
  end

  private

  def room_availability
    if room.bookings.where('check_in_date < ? AND check_out_date > ?', check_out_date, check_in_date).exists?
      errors.add(:base, 'Não está disponível neste período')
    end
  end

  def room_capacity
    if number_of_guests > room.max_people
      errors.add(:base, 'Não comporta este número de pessoas')
    end
  end
end
