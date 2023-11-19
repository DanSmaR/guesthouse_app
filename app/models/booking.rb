class Booking < ApplicationRecord
  # TODO: change the dates and hours to be datetime in one field
  validates :check_in_date, :check_out_date, :number_of_guests, presence: true
  validates :number_of_guests, numericality: { greater_than: 0 }
  validates :reservation_code, uniqueness: true, length: { is: 8 }
  validate :check_in_date_not_in_past, on: :create
  validate :check_dates
  validate :no_overlapping_bookings

  enum status: { pending: 0, active: 1, finished: 2, canceled: 3 }
  belongs_to :room
  belongs_to :guest

  def prepare_for_creation(guesthouse, guest)
    self.guest = guest
    self.status = 0
    self.reservation_code = generate_reservation_code
    self.check_in_hour = guesthouse.checkin_hour
    self.check_out_hour = guesthouse.checkout_hour
    self.total_price = get_total_price
  end

  def check_availability
    check_in_date_not_in_past
    check_dates
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

  def get_total_price
    total = 0
    (check_in_date...check_out_date).each do |date|
      rate = room.room_rates.where('start_date <= ? AND end_date >= ?', date, date).first
      total += rate ? rate.daily_rate : room.daily_rate
    end
    total
  end

  def can_check_in
    unless pending?
      errors.add(:base, 'A reserva não está pendente')
    end
    unless check_in_date <= Date.today
      errors.add(:base, 'Data de check-in ainda não chegou')
    end
    unless check_out_date > Date.today
      errors.add(:base, 'Reserva expirada. Favor cancelar')
    end
    unless check_in_hour <= Time.now
      errors.add(:check_in_hour, 'é antes da hora de check-in padrão da pousada')
    end
    errors.empty?
  end

  private

  def check_dates
    if check_in_date && check_in_date >= check_out_date
      errors.add(:check_in_date, "deve ser antes da data de check-out")
    end
  end
  def generate_reservation_code
    loop do
      code = SecureRandom.alphanumeric(8)
      break code unless Booking.exists?(reservation_code: code)
    end
  end

  def room_availability
    if room.bookings.where(status: [0, 1]).where('check_in_date < ? AND check_out_date > ?', check_out_date, check_in_date).exists?
      errors.add(:base, 'Não está disponível neste período')
    end
  end

  def room_capacity
    if number_of_guests > room.max_people
      errors.add(:base, 'Não comporta este número de pessoas')
    end
  end

  def check_in_date_not_in_past
    if self.check_in_date && self.check_in_date < Date.today
      errors.add(:check_in_date, "não pode ser no passado")
    end
  end

  def no_overlapping_bookings
    overlapping_bookings = room.bookings.where.not(id: id).where(status: [0, 1]).where(
      "NOT (check_in_date >= :end_date OR check_out_date <= :start_date)",
      start_date: check_in_date,
      end_date: check_out_date
    )

    if overlapping_bookings.exists?
      errors.add(:base, "Não está disponível neste período")
    end
  end
end
