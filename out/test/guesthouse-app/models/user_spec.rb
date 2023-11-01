require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    it 'false when name is empty' do
      # Arrange
      user = User.new(name: '', email: 'contato@email.com',
                      password: 'password')

      # Act
      result = user.valid?

      # Assert
      expect(result).to eq false
    end

    it 'false when email is empty' do
      # Arrange
      user = User.new(name: 'João', email: '',
                      password: 'password')

      # Act
      result = user.valid?

      # Assert
      expect(result).to eq false
    end

    it 'false when password is empty' do
      # Arrange
      user = User.new(name: 'João', email: 'contato@email.com',
                      password: '')

      # Act
      result = user.valid?

      # Assert
      expect(result).to eq false
    end
  end
end
