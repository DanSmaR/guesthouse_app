class Guesthouse < ApplicationRecord
  validates :corporate_name, :brand_name, :registration_code, :phone_number, :email, presence: true
  belongs_to :address
  belongs_to :guesthouse_owner
  has_and_belongs_to_many :payment_methods
  accepts_nested_attributes_for :address
end
