class Guesthouse < ApplicationRecord
  validates :corporate_name, :brand_name, :registration_code, :phone_number, :email, presence: true
  validates_associated :address
  validates_presence_of :address
  belongs_to :address, dependent: :destroy, inverse_of: :guesthouse
  belongs_to :guesthouse_owner
  has_and_belongs_to_many :payment_methods
  has_many :rooms, dependent: :destroy
  accepts_nested_attributes_for :address

  validate :at_least_one_payment_method

  private

  def at_least_one_payment_method
    errors.add(:payment_methods, "at least one payment method must be present") if payment_methods.empty?
  end
end
