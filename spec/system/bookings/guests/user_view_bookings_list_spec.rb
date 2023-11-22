require 'rails_helper'

describe 'User access his bookings list' do
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

      guesthouse.rooms.first&.bookings&.create!([{check_in_date: 2.days.from_now, check_out_date: 4.days.from_now,
                                                number_of_guests: 2, guest: guest, total_price: 200, status: 0,
                                                check_in_hour: '14:00', check_out_hour: '12:00',
                                                reservation_code: 'A123AC12'},
                                                {check_in_date: 4.days.from_now, check_out_date: 5.days.from_now,
                                                 number_of_guests: 2, guest: guest, total_price: 100, status: 0,
                                                 check_in_hour: '14:00', check_out_hour: '12:00',
                                                 reservation_code: 'B123AC13'}])

      # Act
      login_as user2, scope: :user
      visit root_path
      click_on 'Minhas Reservas'

      # Assert
      expect(page).to have_selector('th', text: Booking.human_attribute_name(:reservation_code))
      expect(page).to have_selector('th', text: Booking.human_attribute_name(:status))
      expect(page).to have_selector('th', text: Booking.human_attribute_name(:check_in_date))
      expect(page).to have_selector('th', text: Booking.human_attribute_name(:check_out_date))
      expect(page).to have_selector('th', text: Booking.human_attribute_name(:room))
      expect(page).to have_selector('th', text: Guesthouse.model_name.human)
      expect(page).to have_selector('th', text: Booking.human_attribute_name(:total_price))
      expect(page).to have_selector('th', text: 'Ações')
      expect(current_path).to eq(bookings_path)
      expect(page).to have_content('Reservas')
      expect(page).to have_content('Pousada Nascer do Sol', count: 2)
      expect(page).to have_content('Quarto Primavera', count: 2)
      expect(page).to have_content(2.day.from_now.strftime('%d/%m/%Y'))
      expect(page).to have_content(4.days.from_now.strftime('%d/%m/%Y'), count: 2)
      expect(page).to have_content(5.days.from_now.strftime('%d/%m/%Y'))
      expect(page).to have_content('R$ 200,00')
      expect(page).to have_content('R$ 100,00')
      expect(page).to have_content('Pendente', count: 2)
      expect(page).to have_content('A123AC12')
      expect(page).to have_content('B123AC13')
      expect(page).to have_button('Cancelar', count: 2)
      expect(page).to have_link('Detalhes', href: booking_path(Booking.first))
      expect(page).to have_link('Detalhes', href: booking_path(Booking.last))
    end
    it 'and sees finished bookings' do
      # Arrange
      cities = %w[Itapetininga Camboriú]
      states = %w[SP SC]
      guesthouses_names = %w[Pousada\ Nascer\ do\ Sol Praiana]
      user_names = %w[Joao Cesar]
      guesthouse =  {
        0 => '', 1 => ''
      }
      user = {
        0 => '', 1 => ''
      }
      guesthouse_owner = {
        0 => '', 1 => ''
      }

      PaymentMethod.create!(method: 'credit_card')
      PaymentMethod.create!(method: 'debit_card')
      PaymentMethod.create!(method: 'pix')

      user3 = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password', role: 0)
      guest = user3.create_guest!(name: 'Maria', surname: 'Silva', identification_register_number: '12345678910')

      guesthouses_names.each_with_index do |name, index|
        user[index] = User.create!(name: user_names[index], email: "#{user_names[index].downcase}@email.com",
                                   password: 'password', role: 1)
        guesthouse_owner[index] = user[index].build_guesthouse_owner
        guesthouse[index] = guesthouse_owner[index].build_guesthouse(corporate_name: "#{name} LTDA.",
                                                                     brand_name: "Pousada #{name}",
                                                                     registration_code: "#{index}47032102000152",
                                                                     phone_number: "#{index}1598308183",
                                                                     email: "contato@#{name.downcase.gsub(" ", "")}.com.br",
                                                                     description: "Descrição da Pousada #{name}",
                                                                     pets: index.odd? ? true : false,
                                                                     use_policy: 'Não é permitido fumar nas dependências da pousada',
                                                                     checkin_hour: '14:00', checkout_hour: '12:00',
                                                                     active: true)

        guesthouse[index].build_address(street: index.odd? ? "Rua #{index},  #{index}000" : "Avenida #{index}, #{index}000",
                                        neighborhood: index.even? ? "Bairro #{index}" : "Centro #{index}",
                                        city: cities[index], state: states[index], postal_code: "#{index}1001-000")

        guesthouse[index].payment_methods = PaymentMethod.all
        guesthouse[index].save!

        guesthouse[index].rooms.create!([{ name: "Quarto Aquarela #{index}",
                                           description: 'Quarto com vista para a serra',
                                           size: 30, max_people: 2, daily_rate: 100,
                                           bathroom: true, balcony: true,
                                           air_conditioning: index.even? ? true : false,
                                           tv: index.even? ? true : false, wardrobe: true,
                                           safe: true, accessible: index.even? ? true : false,
                                           available: true },
                                         { name: "Quarto Oceano #{index}",
                                           description: 'Quarto com vista para o mar',
                                           size: 30, max_people: 2, daily_rate: 100,
                                           bathroom: true, balcony: true,
                                           air_conditioning: index == 0 ? false : true,
                                           tv: index == 1 ? false : true, wardrobe: true,
                                           safe: true, accessible: index == 0 ? false : true,
                                           available: index.odd? ? true : false }])
        guesthouse[index].rooms.first&.room_rates&.create!([{ start_date: 3.days.from_now,
                                                              end_date: 20.days.from_now,
                                                              daily_rate: 200 },
                                                            { start_date: 2.months.from_now,
                                                              end_date: 3.months.from_now,
                                                              daily_rate: 300 }])
        bookings = guesthouse[index].rooms.first&.bookings&.build([{check_in_date: 1.days.from_now, check_out_date: 2.days.from_now,
                                                                    number_of_guests: 2, guest: guest, status: 0,
                                                                    check_in_hour: DateTime.now.beginning_of_day + 1.day + 14.hours,
                                                                    check_out_hour: DateTime.now.beginning_of_day + 1.day + 12.hours,
                                                                    reservation_code: "#{index}A123AC1"},
                                                                   {check_in_date: 2.days.from_now, check_out_date: 5.days.from_now,
                                                                    number_of_guests: 2, guest: guest, status: 0,
                                                                    check_in_hour: DateTime.now.beginning_of_day + 2.day + 14.hours,
                                                                    check_out_hour: DateTime.now.beginning_of_day + 1.day + 12.hours,
                                                                    reservation_code: "#{index}B123AC1"}])
        bookings&.each do |booking|
          booking.total_price = booking.get_total_price
          booking.save!
          booking.create_booking_rates
        end
      end

      # Act
      login_as user[0], scope: :user
      visit guesthouse_owner_bookings_path
      travel_to Time.new(0.year.from_now.year, 0.month.from_now.month, 2.days.from_now.day, 14, 0, 0) do
        page.all('button', text: 'Check-In')[1].click
        click_on 'Estadias Ativas'
      end

      travel_to Time.new(0.year.from_now.year, 0.month.from_now.month, 5.days.from_now.day, 12, 0, 0) do
        click_on 'Check-Out', match: :first
        select 'Cartão de crédito', from: 'payment_method'
        click_on 'Confirmar'
        click_on 'Sair'
        login_as user3, scope: :user
        click_on 'Entrar'
        click_on 'Minhas Reservas'

        # Assert
        expect(page).to have_content('Pousada Nascer do Sol', count: 2)
        expect(page).to have_content('Pousada Praiana', count: 2)
        expect(page).to have_content('Quarto Aquarela 0', count: 2)
        expect(page).to have_content('Quarto Aquarela 1', count: 2)
        expect(page).to have_content(-4.day.from_now.strftime('%d/%m/%Y'))
        expect(page).to have_content(-3.days.from_now.strftime('%d/%m/%Y'), count: 4)
        expect(page).to have_content(0.days.from_now.strftime('%d/%m/%Y'))
        expect(page).to have_content('R$ 100,00', count: 2)
        expect(page).to have_content('R$ 500,00', count: 2)
        expect(page).to have_content('Pendente', count: 3)
        expect(page).to have_content('Finalizada', count: 1)
        expect(page).to have_content('0A123AC1')
        expect(page).to have_content('1A123AC1')
        expect(page).to have_content('0B123AC1')
        expect(page).to have_content('1B123AC1')
        expect(page).to have_button('Cancelar', count: 3)
        expect(page).to have_link('Detalhes', count: 4)
      end
    end
  end
  context 'and has no bookings' do
    it 'shows a alert message only' do
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

      # Act
      login_as user2, scope: :user
      visit root_path
      click_on 'Minhas Reservas'

      # Assert
      expect(page).to have_content('Nenhuma reserva encontrada')
    end
  end
end