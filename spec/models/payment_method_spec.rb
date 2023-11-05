require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  describe 'validations' do
    it 'must be unique' do
      PaymentMethod.create!(method: 'credit_card')
      payment_method = PaymentMethod.new(method: 'credit_card')
      payment_method.valid?
      expect(payment_method.errors[:method]).to include('já está em uso')
    end
  end
end
