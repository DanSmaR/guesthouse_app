require 'rails_helper'

RSpec.describe Guesthouse, type: :model do
  describe '#valid?' do
    it 'false when corporate_name is empty' do
      # Arrange
      guesthouse = Guesthouse.new(corporate_name: '', brand_name: 'Pousada Nascer do Sol',
                                  registration_code: '47032102000152', phone_number: '15983081833',
                                  email: 'contato@email.com',
                                  description: 'Pousada com vista linda para a serra',
                                  payment_method: 0, pets: true,
                                  use_policy: 'Não é permitido fumar nas dependências da pousada',
                                  checkin_hour: '14:00', checkout_hour: '12:00', active: true)
      # Act
      result = guesthouse.valid?

      # Assert
      expect(result).to eq false
    end

    it 'false when brand_name is empty' do
      # Arrange
      guesthouse = Guesthouse.new(corporate_name: 'Pousada Nascer do Sol LTDA.', brand_name: '',
                                  registration_code: '47032102000152', phone_number: '15983081833',
                                  email: 'contato@email.com',
                                  description: 'Pousada com vista linda para a serra',
                                  payment_method: 0, pets: true,
                                  use_policy: 'Não é permitido fumar nas dependências da pousada',
                                  checkin_hour: '14:00', checkout_hour: '12:00', active: true)
      # Act
      result = guesthouse.valid?

      # Assert
      expect(result).to eq false
    end

    it 'false when registration_code is empty' do
      # Arrange
      guesthouse = Guesthouse.new(corporate_name: 'Pousada Nascer do Sol LTDA.', brand_name: 'Pousada Nascer do Sol',
                                  registration_code: '', phone_number: '15983081833',
                                  email: 'contato@email.com',
                                  description: 'Pousada com vista linda para a serra',
                                  payment_method: 0, pets: true,
                                  use_policy: 'Não é permitido fumar nas dependências da pousada',
                                  checkin_hour: '14:00', checkout_hour: '12:00', active: true)
      # Act
      result = guesthouse.valid?

      # Assert
      expect(result).to eq false
    end

    it 'false when phone_number is empty' do
      # Arrange
      guesthouse = Guesthouse.new(corporate_name: 'Pousada Nascer do Sol LTDA.', brand_name: 'Pousada Nascer do Sol',
                                  registration_code: '47032102000152', phone_number: '',
                                  email: 'contato@email.com',
                                  description: 'Pousada com vista linda para a serra',
                                  payment_method: 0, pets: true,
                                  use_policy: 'Não é permitido fumar nas dependências da pousada',
                                  checkin_hour: '14:00', checkout_hour: '12:00', active: true)
      # Act
      result = guesthouse.valid?

      # Assert
      expect(result).to eq false
    end

    it 'false when email is empty' do
      # Arrange
      guesthouse = Guesthouse.new(corporate_name: 'Pousada Nascer do Sol LTDA.', brand_name: 'Pousada Nascer do Sol',
                                  registration_code: '47032102000152', phone_number: '15983081833',
                                  email: '',
                                  description: 'Pousada com vista linda para a serra',
                                  payment_method: 0, pets: true,
                                  use_policy: 'Não é permitido fumar nas dependências da pousada',
                                  checkin_hour: '14:00', checkout_hour: '12:00', active: true)
      # Act
      result = guesthouse.valid?

      # Assert
      expect(result).to eq false
    end
  end
end
