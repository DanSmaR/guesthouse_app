require 'rails_helper'

describe 'User views rooms' do
  context  'as guesthouse owner' do
    it 'successfully' do
      # Arrange
      user = User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 1)
      guesthouse_owner = user.build_guesthouse_owner
      guesthouse = guesthouse_owner.build_guesthouse(corporate_name: 'Pousada Nascer do Sol LTDA.',
                                                     brand_name: 'Pousada Nascer do Sol',
                                                     registration_code: '47032102000152',
                                                     phone_number: '15983081833',
                                                     email: 'contato@nascerdosol.com.br',
                                                     description: 'Pousada com vista linda para a serra',
                                                     pets: true,
                                                     use_policy: 'Não é permitido fumar nas dependências da pousada',
                                                     checkin_hour: '14:00', checkout_hour: '12:00', active: true)
      guesthouse.build_address(street: 'Rua das Flores, 1000', neighborhood: 'Vila Belo Horizonte' ,
                               city: 'Itapetininga', state: 'SP', postal_code: '01001-000')

      PaymentMethod.create!(method: 'credit_card')
      PaymentMethod.create!(method: 'debit_card')
      PaymentMethod.create!(method: 'pix')

      guesthouse.payment_methods = PaymentMethod.all
      guesthouse.rooms.build([{ name: 'Quarto Primavera', description: 'Quarto com vista para a serra', size: 30,
                                maximum_occupancy: 2, daily_rate: 100, bathroom: true, balcony: true,
                                air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                available: true },
                              { name: 'Quarto Verão', description: 'Quarto com vista para o mar', size: 30,
                                maximum_occupancy: 2, daily_rate: 100, bathroom: true, balcony: true,
                                air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                available: false }])

      guesthouse.save!

      # Act
      login_as(user)
      visit root_path
      click_on 'Pousada Nascer do Sol'
      click_on 'Quartos'

      # Assert
      expect(page).to have_content('Quarto Primavera')
      expect(page).to have_content('Quarto com vista para a serra')
      expect(page).to have_content('30 m²')
      expect(page).to have_content('2 pessoas')
      expect(page).to have_content('R$ 100,00')
      expect(page).to have_content('Banheiro')
      expect(page).to have_content('Varanda')
      expect(page).to have_content('Ar condicionado')
      expect(page).to have_content('TV')
      expect(page).to have_content('Guarda-roupa')
      expect(page).to have_content('Cofre')
      expect(page).to have_content('Accessível para PCDs')
      expect(page).to have_content('Disponível')

      expect(page).to have_content('Quarto Verão')
      expect(page).to have_content('Quarto com vista para o mar')
      expect(page).to have_content('30 m²')
      expect(page).to have_content('2 pessoas')
      expect(page).to have_content('R$ 100,00')
      expect(page).to have_content('Banheiro')
      expect(page).to have_content('Varanda')
      expect(page).to have_content('Ar condicionado')
      expect(page).to have_content('TV')
      expect(page).to have_content('Guarda-roupa')
      expect(page).to have_content('Cofre')
      expect(page).to have_content('Accessível para PCDs')
      expect(page).to have_content('Indisponível')
    end
  end

  context 'as visitant' do
    it 'successfully views available rooms' do
      # Arrange
      user = User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 1)
      guesthouse_owner = user.build_guesthouse_owner
      guesthouse = guesthouse_owner.build_guesthouse(corporate_name: 'Pousada Nascer do Sol LTDA.',
                                                     brand_name: 'Pousada Nascer do Sol',
                                                     registration_code: '47032102000152',
                                                     phone_number: '15983081833',
                                                     email: 'contato@nascerdosol.com.br',
                                                     description: 'Pousada com vista linda para a serra',
                                                     pets: true,
                                                     use_policy: 'Não é permitido fumar nas dependências da pousada',
                                                     checkin_hour: '14:00', checkout_hour: '12:00', active: true)
      guesthouse.build_address(street: 'Rua das Flores, 1000', neighborhood: 'Vila Belo Horizonte' ,
                               city: 'Itapetininga', state: 'SP', postal_code: '01001-000')

      PaymentMethod.create!(method: 'credit_card')
      PaymentMethod.create!(method: 'debit_card')
      PaymentMethod.create!(method: 'pix')

      guesthouse.payment_methods = PaymentMethod.all
      guesthouse.rooms.build([{ name: 'Quarto Primavera', description: 'Quarto com vista para a serra', size: 30,
                                maximum_occupancy: 2, daily_rate: 100, bathroom: true, balcony: true,
                                air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                available: true },
                              { name: 'Quarto Verão', description: 'Quarto com vista para o mar', size: 30,
                                maximum_occupancy: 2, daily_rate: 100, bathroom: true, balcony: true,
                                air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                available: false }])

      guesthouse.save!

      # Act
      visit root_path
      click_on 'Pousada Nascer do Sol'
      click_on 'Quartos'

      # Assert
      expect(page).to have_content('Quarto Primavera')
      expect(page).to have_content('Quarto com vista para a serra')
      expect(page).to have_content('30 m²')
      expect(page).to have_content('2 pessoas')
      expect(page).to have_content('R$ 100,00')
      expect(page).to have_content('Banheiro')
      expect(page).to have_content('Varanda')
      expect(page).to have_content('Ar condicionado')
      expect(page).to have_content('TV')
      expect(page).to have_content('Guarda-roupa')
      expect(page).to have_content('Cofre')
      expect(page).to have_content('Accessível para PCDs')
      expect(page).to have_content('Disponível')

      expect(page).to_not have_content('Quarto Verão')
      expect(page).to_not have_content('Quarto com vista para o mar')
      expect(page).to_not have_content('Indisponível')
    end
  end

  context 'as another owner' do
    it 'views only available rooms' do
      # Arrange
      # User 1
      user = User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 1)
      guesthouse_owner = user.build_guesthouse_owner
      guesthouse = guesthouse_owner.build_guesthouse(corporate_name: 'Pousada Nascer do Sol LTDA.',
                                                     brand_name: 'Pousada Nascer do Sol',
                                                     registration_code: '47032102000152',
                                                     phone_number: '15983081833',
                                                     email: 'contato@nascerdosol.com.br',
                                                     description: 'Pousada com vista linda para a serra',
                                                     pets: true,
                                                     use_policy: 'Não é permitido fumar nas dependências da pousada',
                                                     checkin_hour: '14:00', checkout_hour: '12:00', active: true)
      guesthouse.build_address(street: 'Rua das Flores, 1000', neighborhood: 'Vila Belo Horizonte' ,
                               city: 'Itapetininga', state: 'SP', postal_code: '01001-000')

      PaymentMethod.create!(method: 'credit_card')
      PaymentMethod.create!(method: 'debit_card')
      PaymentMethod.create!(method: 'pix')

      guesthouse.payment_methods = PaymentMethod.all

      guesthouse.rooms.build([{ name: 'Quarto Primavera', description: 'Quarto com vista para a serra', size: 30,
                                maximum_occupancy: 2, daily_rate: 100, bathroom: true, balcony: true,
                                air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                available: true },
                              { name: 'Quarto Verão', description: 'Quarto com vista para o mar', size: 30,
                                maximum_occupancy: 2, daily_rate: 100, bathroom: true, balcony: true,
                                air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                available: false }])
      guesthouse.save!

      # User 2
      user2 = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password', role: 1)
      guesthouse_owner2 = user2.build_guesthouse_owner
      guesthouse2 = guesthouse_owner2.build_guesthouse(corporate_name: 'Casa do Saber LTDA.',
                                                       brand_name: 'Casa do Saber',
                                                       registration_code: '47032102000152',
                                                       phone_number: '15983081833',
                                                       email: 'contato@casadosaber.com.br',
                                                       description: 'Pousada com muito conhecimeto',
                                                       pets: true,
                                                       use_policy: 'Não é permitido fumar nas dependências da pousada',
                                                       checkin_hour: '14:00', checkout_hour: '12:00', active: true)
      guesthouse2.build_address(street: 'Rua da Sucata, 1000', neighborhood: 'Vila Minas Gerais' ,
                                city: 'Itapevi', state: 'SP', postal_code: '01001-000')
      PaymentMethod.create!(method: 'credit_card')
      PaymentMethod.create!(method: 'debit_card')
      PaymentMethod.create!(method: 'pix')
      guesthouse2.payment_methods = PaymentMethod.all
      guesthouse2.save!

      # Act
      login_as(user2)
      visit root_path
      click_on 'Pousada Nascer do Sol'
      click_on 'Quartos'

      # Assert
      expect(page).to have_content('Quarto Primavera')
      expect(page).to have_content('Quarto com vista para a serra')
      expect(page).to have_content('30 m²')
      expect(page).to have_content('2 pessoas')
      expect(page).to have_content('R$ 100,00')
      expect(page).to have_content('Banheiro')
      expect(page).to have_content('Varanda')
      expect(page).to have_content('Ar condicionado')
      expect(page).to have_content('TV')
      expect(page).to have_content('Guarda-roupa')
      expect(page).to have_content('Cofre')
      expect(page).to have_content('Accessível para PCDs')
      expect(page).to have_content('Disponível')

      expect(page).to_not have_content('Quarto Verão')
      expect(page).to_not have_content('Quarto com vista para o mar')
      expect(page).to_not have_content('Indisponível')
    end
  end
end