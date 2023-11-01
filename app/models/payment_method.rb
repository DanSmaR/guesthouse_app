class PaymentMethod < ApplicationRecord
  enum method: { credit_card: 0, debit_card: 1, pix: 2 }
  has_and_belongs_to_many :guesthouses
end