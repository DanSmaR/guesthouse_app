require 'rails_helper'

RSpec.describe Address, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  describe '#valid?' do
    it 'street is mandatory' do
      # Arrange
      # empty street to force error
      address = Address.new(street: '', neighborhood: 'Vila Belo Horizonte' ,
                            city: 'Itapetininga', state: 'SP', postal_code: '01001-000')

      # Act
      is_valid = address.valid?

      # Assert
      expect(is_valid).to eq false
    end

    it 'neighborhood is mandatory' do
      # Arrange
      # empty neighborhood to force error
      address = Address.new(street: 'Rua das Flores, 1000', neighborhood: '' ,
                            city: 'Itapetininga', state: 'SP', postal_code: '01001-000')

      # Act
      is_valid = address.valid?

      # Assert
      expect(is_valid).to eq false
    end

    it 'city is mandatory' do
      # Arrange
      # empty city to force error
      address = Address.new(street: 'Rua das Flores, 1000', neighborhood: 'Vila Belo Horizonte' ,
                            city: '', state: 'SP', postal_code: '01001-000')

      # Act
      is_valid = address.valid?

      # Assert
      expect(is_valid).to eq false
    end

    it 'state is mandatory' do
      # Arrange
      # empty state to force error
      address = Address.new(street: 'Rua das Flores, 1000', neighborhood: 'Vila Belo Horizonte' ,
                            city: 'Itapetininga', state: '', postal_code: '01001-000')

      # Act
      is_valid = address.valid?

      # Assert
      expect(is_valid).to eq false
    end

    it 'raises an error when passing invalid state' do
      expect { Address.new(street: 'Rua das Flores, 1000', neighborhood: 'Vila Belo Horizonte' ,
                            city: 'Itapetininga', state: 'XX', postal_code: '01001-000') }
        .to raise_error(ArgumentError)
    end

    it 'postal_code is mandatory' do
      # Arrange
      # empty postal_code to force error
      address = Address.new(street: 'Rua das Flores, 1000', neighborhood: 'Vila Belo Horizonte' ,
                            city: 'Itapetininga', state: 'SP', postal_code: '')

      # Act
      is_valid = address.valid?

      # Assert
      expect(is_valid).to eq false
    end
  end
end
