class Guesthouse < ApplicationRecord
  belongs_to :address
  belongs_to :guesthouse_owner

  enum payment_method: { credit_card: 0, debit_card: 1, pix: 2 }
end
