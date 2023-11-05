class PaymentMethod < ApplicationRecord
  validates :method, presence: true
  enum method: { credit_card: 0, debit_card: 1, pix: 2 }
  has_and_belongs_to_many :guesthouses
  validates :method, uniqueness: true, if: :exist_payment_method

  def exist_payment_method
    result = PaymentMethod.where(method: method).exists?
    if result
      errors.add(:method, 'já está em uso')
    end
  end
end