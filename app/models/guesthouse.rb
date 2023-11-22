class Guesthouse < ApplicationRecord
  validates :corporate_name, :brand_name, :registration_code, :phone_number, :email, presence: true
  validates_associated :address
  validates_presence_of :address
  belongs_to :address, dependent: :destroy, inverse_of: :guesthouse
  belongs_to :guesthouse_owner
  has_and_belongs_to_many :payment_methods
  has_many :rooms, dependent: :destroy, inverse_of: :guesthouse
  accepts_nested_attributes_for :address

  validate :at_least_one_payment_method

  before_create :only_one_guesthouse_per_owner
  before_update :only_one_guesthouse_per_owner

  def self.search_general(query)
    guesthouses = joins(:address)
                    .where(active: true)
                    .where('brand_name LIKE ? OR neighborhood LIKE ? OR city LIKE ?',
                                        "%#{query}%", "%#{query}%", "%#{query}%")
    guesthouses.order(:brand_name)
  end

  def self.search_advanced(query, options)
    guesthouses = joins(:address).joins(:rooms).where(active: true, rooms: { available: true })
    if query.present?
      guesthouses = guesthouses.where('brand_name LIKE ? OR neighborhood LIKE ? OR city LIKE ?',
                                      "%#{query}%", "%#{query}%", "%#{query}%")
    end

    guesthouses = guesthouses.where(pets: options[:pets]) if options[:pets].present?
    guesthouses = guesthouses.where(rooms: {
      accessible: options[:accessible] }) if options[:accessible].present?
    guesthouses = guesthouses.where(rooms: {
      air_conditioning: options[:air_conditioning] }) if options[:air_conditioning].present?
    guesthouses = guesthouses.where(rooms: { tv: options[:tv] }) if options[:tv].present?

    # Eliminate duplicates
    guesthouses = guesthouses.distinct

    guesthouses.order(:brand_name)
  end

  def self.search_by_city(query)
    joins(:address)
      .where(active: true, addresses: { city: query })
      .order(:brand_name)
  end

  def average_rating
    reviews = Review.joins(booking: { room: :guesthouse }).where(guesthouses: { id: id })
    reviews.average(:rating)&.round
  end

  private

  def at_least_one_payment_method
    errors.add(:payment_methods, 'não pode ficar em branco') if payment_method_ids.empty?
  end


  def only_one_guesthouse_per_owner
    if new_record? && Guesthouse.where(guesthouse_owner_id: guesthouse_owner_id).exists?
      add_on_owner_error
    elsif Guesthouse.where(guesthouse_owner_id: guesthouse_owner_id).where.not(id: id).exists?
      add_on_owner_error
    end
  end

  def add_on_owner_error
    errors.add(:base, 'pode ter apenas uma pousada')
    throw(:abort)
  end
end