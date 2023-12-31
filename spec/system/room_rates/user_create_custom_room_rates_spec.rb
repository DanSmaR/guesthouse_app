require 'rails_helper'

describe 'User create custom room rates' do
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
    guesthouse.save!
    guesthouse.rooms.create!([{ name: 'Quarto Primavera', description: 'Quarto com vista para a serra', size: 30,
                                max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                                air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                available: true },
                              { name: 'Quarto Verão', description: 'Quarto com vista para o mar', size: 30,
                                max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                                air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                available: false }])

    # Act
    login_as user
    visit guesthouse_room_path(guesthouse, guesthouse.rooms.first)
    click_on 'Criar Diária por Período'
    fill_in 'Valor', with: 100
    fill_in 'Data de início', with: '01/01/2021'
    fill_in 'Data de término', with: '31/01/2021'
    click_on 'Criar Diária por Período'

    # Assert
    expect(page).to have_content('Diárias por Período')
    within 'section#room_rates' do
      expect(page).to have_content('Valor', count: 1)
      expect(page).to have_content('Período', count: 3)
      expect(page).to have_content('R$ 100,00')
      expect(page).to have_content('01/01/2021 - 31/01/2021')
    end

  end

  context 'when there is a custom rate already registered' do
    it 'successfully' do
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
      guesthouse.save!
      guesthouse.rooms.create!([{ name: 'Quarto Primavera', description: 'Quarto com vista para a serra', size: 30,
                                  max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                                  air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                  available: true },
                                { name: 'Quarto Verão', description: 'Quarto com vista para o mar', size: 30,
                                  max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                                  air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                  available: false }])
      guesthouse.rooms.first&.room_rates&.create!([{ start_date: '2021-01-15', end_date: '2021-01-31', daily_rate: 100 },
                                                   { start_date: '2021-02-01', end_date: '2021-02-28', daily_rate: 200 }])

      # Act
      login_as user
      visit guesthouse_room_path(guesthouse, guesthouse.rooms.first)
      click_on 'Criar Diária por Período'
      fill_in 'Valor', with: 100
      fill_in 'Data de início', with: '01/01/2021'
      fill_in 'Data de término', with: '14/01/2021'
      click_on 'Criar Diária por Período'

      # Assert
      expect(page).to have_content('Diária cadastrada com sucesso')
      expect(page).to have_content('Diárias por Período')
      within 'section#room_rates' do
        expect(page).to have_content('Valor', count: 3)
        expect(page).to have_content('Período', count: 5)
        expect(page).to have_content('R$ 100,00')
        expect(page).to have_content('01/01/2021 - 14/01/2021')
        expect(page).to have_content('15/01/2021 - 31/01/2021')
        expect(page).to have_content('01/02/2021 - 28/02/2021')
      end
    end

  end

  it 'and must fill in all fields' do
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
    guesthouse.save!
    guesthouse.rooms.create!([{ name: 'Quarto Primavera', description: 'Quarto com vista para a serra', size: 30,
                                max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                                air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                available: true },
                              { name: 'Quarto Verão', description: 'Quarto com vista para o mar', size: 30,
                                max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                                air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                available: false }])

    # Act
    login_as user
    visit guesthouse_room_path(guesthouse, guesthouse.rooms.first)
    click_on 'Criar Diária por Período'
    fill_in 'Valor', with: ''
    fill_in 'Data de início', with: ''
    fill_in 'Data de término', with: ''
    click_on 'Criar Diária por Período'

    # Assert
    expect(page).to have_content('Não foi possível cadastrar a diária')
    expect(page).to have_content('Valor da diária não pode ficar em branco')
    expect(page).to have_content('Data de início não pode ficar em branco')
    expect(page).to have_content('Data de término não pode ficar em branco')
  end

  context 'when dates is overlapping others periods' do
    it 'does not create' do
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
      guesthouse.save!
      guesthouse.rooms.create!([{ name: 'Quarto Primavera', description: 'Quarto com vista para a serra', size: 30,
                                  max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                                  air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                  available: true },
                                { name: 'Quarto Verão', description: 'Quarto com vista para o mar', size: 30,
                                  max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                                  air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                  available: false }])
      guesthouse.rooms.first&.room_rates&.create!([{ start_date: '2021-01-15', end_date: '2021-01-31', daily_rate: 100 },
                                                    { start_date: '2021-02-01', end_date: '2021-02-28', daily_rate: 200 }])

      # Act
      login_as user
      visit guesthouse_room_path(guesthouse, guesthouse.rooms.first)
      click_on 'Criar Diária por Período'
      fill_in 'Valor', with: 100
      fill_in 'Data de início', with: '01/01/2021'
      fill_in 'Data de término', with: '16/01/2021'
      click_on 'Criar Diária por Período'

      # Assert
      expect(page).to have_content('Não foi possível cadastrar a diária')
      expect(page).to have_content('Essas datas estão sobrepostas a uma diária já cadastrada')
    end
  end

#   TODO - cannot access this page by typing the url
end
