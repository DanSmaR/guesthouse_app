require 'rails_helper'

describe 'Guesthouse owner check-out active guesthouse bookings' do
  it 'and goes to check-out confirmation' do
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

      # Assert
      expect(current_path).to eq(check_out_booking_path(2))
      expect(page).to have_content('Código da Reserva: 0B123AC1')
      expect(page).to have_content('Quarto Aquarela 0')
      expect(page).to have_content('Pousada Nascer do Sol')
      expect(page).to have_content('Confirmação do Check-Out')
      expect(page).to have_content('Valor total a ser pago: R$ 500,00')
      expect(page).to have_select('payment_method', options: ['Selecione o método de pagamento', 'Cartão de crédito', 'Cartão de débito', 'Pix'])
    end
  end

  it 'and confirm the check-out' do
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

      # Assert
      expect(current_path).to eq(booking_path(2))
      expect(page).to have_content('Check-out realizado com sucesso!')
      expect(page).to have_content('Dados do Check-Out efetivado')
      expect(page).to have_content('Data de Confirmação do Check-out')
      expect(page).to have_content(Time.now.strftime('%d/%m/%Y'))
      expect(page).to have_content('Hora de Confirmação do Check-out')
      expect(page).to have_content(Time.now.strftime('%H:%M'))
      expect(page).to have_content('Total Pago: R$ 500,00')
      expect(page).to have_content('Forma de Pagamento: Cartão de crédito')
    end
  end

  context 'when does not choose a payment method' do
    it 'and confirm the check-out' do
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
        click_on 'Confirmar'

        # Assert
        expect(current_path).to eq(check_out_booking_path(2))
        expect(page).to have_content('Método de Pagamento é obrigatório')
      end
    end
  end
end
