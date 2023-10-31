class Guesthouse < ApplicationRecord
  validates :corporate_name, :brand_name, :registration_code, :phone_number, :email, presence: true
  belongs_to :address
  belongs_to :guesthouse_owner

  enum payment_method: { credit_card: 0, debit_card: 1, pix: 2 }
end
