require 'rails_helper'

describe 'User access room booking' do
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
                                available: true }])


    # Act
    visit root_path
    click_on 'Pousada Nascer do Sol'
    click_on 'Reservar', match: :first

    # Assert
    expect(current_path).to eq(new_room_booking_path(Room.first))
    expect(page).to have_field('Data de Check-in')
    expect(page).to have_field('Data de Check-out')
    expect(page).to have_field('Quantidade de Hóspedes')
    expect(page).to have_button('Verificar Disponibilidade')
    expect(page).to have_content('Quarto Primavera')
    expect(page).to have_content('Descrição: Quarto com vista para a serra')
    expect(page).to have_content('Tamanho: 30 m')
    expect(page).to have_content('Acomodação Máxima: 2')
    expect(page).to have_content('Valor da Diária: R$ 100,00')
    expect(page).to have_content('Banheiro: Sim')
    expect(page).to have_content('Varanda: Sim')
    expect(page).to have_content('Ar Condicionado: Sim')
    expect(page).to have_content('TV: Sim')
    expect(page).to have_content('Guarda-Roupa: Sim')
    expect(page).to have_content('Cofre: Sim')
    expect(page).to have_content('Acessível para PCDs: Sim')
    expect(page).to_not have_content('Disponibilidade: Sim')
  end

  it 'and must fill all fields' do
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
                                available: true }])


    # Act
    visit root_path
    click_on 'Pousada Nascer do Sol'
    click_on 'Reservar', match: :first
    fill_in 'Data de Check-in', with: 1.day.from_now
    fill_in 'Data de Check-out', with: 2.days.from_now
    fill_in 'Quantidade de Hóspedes', with: 2
    click_on 'Verificar Disponibilidade'

    # Assert
    expect(current_path).to eq(confirm_room_bookings_path(Room.first))
    expect(page).to have_content('Quarto disponível!')
    expect(page).to have_field('Data de Check-in', with: 1.day.from_now.strftime('%Y-%m-%d'))
    expect(page).to have_field('Data de Check-out', with: 2.days.from_now.strftime('%Y-%m-%d'))
    expect(page).to have_field('Quantidade de Hóspedes', with: 2)
    expect(page).to have_content('Preço Total: R$ 100,00')
    expect(page).to have_button('Prosseguir com a Reserva')
  end

  context 'when room is not available' do
    it 'cannot book' do
      # Arrange
      user = User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 1)
      user2 = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password', role: 0)
      guest = user2.create_guest!(name: 'Maria', surname: 'Silva', identification_register_number: '12345678910')
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
                                  available: true }])
      guesthouse.rooms.first&.bookings&.create!(check_in_date: 2.day.from_now, check_out_date: 4.days.from_now,
                                                number_of_guests: 2, guest: guest, total_price: 200, status: 0,
                                                check_in_hour: '14:00', check_out_hour: '12:00', reservation_code: 'A123AC12')


      # Act
      visit root_path
      click_on 'Pousada Nascer do Sol'
      click_on 'Reservar', match: :first
      fill_in 'Data de Check-in', with: 1.day.from_now
      fill_in 'Data de Check-out', with: 3.days.from_now
      fill_in 'Quantidade de Hóspedes', with: 2
      click_on 'Verificar Disponibilidade'

      # Assert
      expect(current_path).to eq(room_availability_path(Room.first))
      expect(page).to have_content('Não está disponível neste período')
    end
  end
end