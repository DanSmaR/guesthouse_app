require 'rails_helper'

describe 'User cancels his booking' do
  context "when logged in" do
    it 'successfully' do
      # Arrange
      user = User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 1)
      guesthouse_owner = user.build_guesthouse_owner
      user2 = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password', role: 0)
      guest = user2.create_guest!(name: 'Maria', surname: 'Silva', identification_register_number: '12345678910')

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

      guesthouse.rooms.first&.bookings&.create!([{check_in_date: 8.days.from_now, check_out_date: 10.days.from_now,
                                                  number_of_guests: 2, guest: guest, total_price: 200, status: 0,
                                                  check_in_hour: '14:00', check_out_hour: '12:00',
                                                  reservation_code: 'A123AC12'},
                                                 {check_in_date: 10.days.from_now, check_out_date: 11.days.from_now,
                                                  number_of_guests: 2, guest: guest, total_price: 100, status: 0,
                                                  check_in_hour: '14:00', check_out_hour: '12:00',
                                                  reservation_code: 'B123AC13'}])

      # Act
      login_as user2, scope: :user
      visit bookings_path
      click_on 'Cancelar', match: :first

      # Assert
      expect(page).to have_content('Reserva cancelada com sucesso!')
      expect(page).to have_content('Pousada Nascer do Sol', count: 1)
      expect(page).to have_content('Quarto Primavera', count: 1)
      expect(page).to have_content(10.days.from_now.strftime('%d/%m/%Y'))
      expect(page).to have_content(11.days.from_now.strftime('%d/%m/%Y'))
      expect(page).to have_content('R$ 100,00')
      expect(page).to have_content('Pendente')
      expect(page).to have_content('B123AC13')
      expect(page).to have_button('Cancelar', count: 1)
      expect(page).to have_link('Detalhes', href: booking_path(Booking.last))
    end

  context 'with less than 7 days in advance' do
    it 'cannot cancel a booking' do
      # Arrange
      user = User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 1)
      guesthouse_owner = user.build_guesthouse_owner
      user2 = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password', role: 0)
      guest = user2.create_guest!(name: 'Maria', surname: 'Silva', identification_register_number: '12345678910')

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

      guesthouse.rooms.first&.bookings&.create!([{check_in_date: 6.days.from_now, check_out_date: 9.days.from_now,
                                                  number_of_guests: 2, guest: guest, total_price: 300, status: 0,
                                                  check_in_hour: '14:00', check_out_hour: '12:00',
                                                  reservation_code: 'A123AC12'},
                                                 {check_in_date: 4.days.from_now, check_out_date: 5.days.from_now,
                                                  number_of_guests: 2, guest: guest, total_price: 100, status: 0,
                                                  check_in_hour: '14:00', check_out_hour: '12:00',
                                                  reservation_code: 'B123AC13'}])

      # Act
      login_as user2, scope: :user
      visit bookings_path
      click_on 'Cancelar', match: :first

      # Assert
      expect(page).to have_content('Não é possível cancelar a reserva com menos de 7 dias de antecedência.')
      expect(page).to have_content('Minhas Reservas')
      expect(page).to have_content('Pousada Nascer do Sol', count: 2)
      expect(page).to have_content('Quarto Primavera', count: 2)
      expect(page).to have_content(6.day.from_now.strftime('%d/%m/%Y'))
      expect(page).to have_content(9.day.from_now.strftime('%d/%m/%Y'))
      expect(page).to have_content(4.days.from_now.strftime('%d/%m/%Y'))
      expect(page).to have_content(5.days.from_now.strftime('%d/%m/%Y'))
      expect(page).to have_content('R$ 300,00')
      expect(page).to have_content('R$ 100,00')
      expect(page).to have_content('Pendente', count: 2)
      expect(page).to have_content('A123AC12')
      expect(page).to have_content('B123AC13')
      expect(page).to have_button('Cancelar', count: 2)
      expect(page).to have_link('Detalhes', href: booking_path(Booking.first))
      expect(page).to have_link('Detalhes', href: booking_path(Booking.last))
    end
  end
  end
end