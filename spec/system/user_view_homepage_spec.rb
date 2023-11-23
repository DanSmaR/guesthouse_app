require 'rails_helper'

describe 'User landing in the home page' do
  context 'as a user logged in' do
    it 'should see some guesthouses' do
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
      # Act
      visit('/')
      # Assert
      expect(page).to_not have_content('Nenhuma pousada cadastrada')
      expect(page).to have_content('Pousada Nascer do Sol')
      expect(page).to have_content('Itapetininga - SP')
    end

    it 'does not see the guesthouse owner menu options' do
      # Arrange
      user = User.create!(name: 'Marcia', email: 'marcia@email.com', password: 'password', role: 0)
      guest = user.build_guest(name: 'Marcia', surname: 'Silva', identification_register_number: '12345678910')

      # Act
      login_as user, scope: :user
      visit('/')

      # Assert
      within 'header' do
        expect(page).to_not have_content('Minhas Pousadas')
        expect(page).to_not have_content('Estadias Ativas')
        expect(page).to_not have_content('Reservas', exact: true)
        expect(page).to_not have_content('Avaliações')
      end
    end

    it 'should not exist registered guesthouses' do
      # Arrange
      # rails already cleaned the database by default

      # Act
      visit('/')

      # Assert
      expect(page).to have_content('Nenhuma pousada cadastrada')
    end
  end

  context 'as a user not logged in' do
    it 'should see the app name' do
      # Arrange
      # Act
      visit('/')

      # Assert
      within 'header' do
        expect(page).to have_content('Pousada App')
        expect(page).to have_content('Entrar')
        expect(page).to_not have_content('Minhas Pousadas')
        expect(page).to_not have_content('Estadias Ativas')
        expect(page).to_not have_content('Reservas', exact: true)
        expect(page).to_not have_content('Avaliações')
      end
      expect(page).to have_content('Sejam bem vindos(as) ao Pousada App')
    end

    it 'should see some guesthouses' do
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

      bookings = {
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
        bookings[index] = guesthouse[index].rooms.first&.bookings&.build([{check_in_date: 1.days.from_now, check_out_date: 2.days.from_now,
                                                                    number_of_guests: 2, guest: guest, status: 0,
                                                                    check_in_hour: DateTime.now.beginning_of_day + 1.day + 14.hours,
                                                                    check_out_hour: DateTime.now.beginning_of_day + 1.day + 12.hours,
                                                                    reservation_code: "#{index}A123AC1"},
                                                                   {check_in_date: 2.days.from_now, check_out_date: 5.days.from_now,
                                                                    number_of_guests: 2, guest: guest, status: 0,
                                                                    check_in_hour: DateTime.now.beginning_of_day + 2.day + 14.hours,
                                                                    check_out_hour: DateTime.now.beginning_of_day + 1.day + 12.hours,
                                                                    reservation_code: "#{index}B123AC1"},
                                                                    {check_in_date: 5.days.from_now, check_out_date: 7.days.from_now,
                                                                    number_of_guests: 2, guest: guest, status: 0,
                                                                    check_in_hour: DateTime.now.beginning_of_day + 5.day + 14.hours,
                                                                    check_out_hour: DateTime.now.beginning_of_day + 1.day + 12.hours,
                                                                    reservation_code: "#{index}C123AC1"},
                                                                    {check_in_date: 7.days.from_now, check_out_date: 10.days.from_now,
                                                                    number_of_guests: 2, guest: guest, status: 0,
                                                                    check_in_hour: DateTime.now.beginning_of_day + 7.day + 14.hours,
                                                                    check_out_hour: DateTime.now.beginning_of_day + 1.day + 12.hours,
                                                                    reservation_code: "#{index}D123AC1"}])
        bookings[index]&.each do |booking|
          booking.total_price = booking.get_total_price
          booking.save!
          booking.create_booking_rates
        end
      end

      travel_to Time.new(0.year.from_now.year, 0.month.from_now.month, 1.days.from_now.day, 14, 0, 0) do
        bookings.each_value do |booking|
          booking.first.update!(check_in_confirmed_date: Date.today, check_in_confirmed_hour: Time.now)
          booking.first.active!
        end
      end

      travel_to Time.new(0.year.from_now.year, 0.month.from_now.month, 2.days.from_now.day, 12, 0, 0) do
        bookings.each_value do |booking|
          booking.first.finished!
          booking.first.update!(check_out_confirmed_date: Date.today, check_out_confirmed_hour: Time.now,
          total_paid: booking.first.calculate_total_paid, payment_method: 'credit_card')
          booking.first.create_review!(rating: 5, comment: 'Muito boa pousada', guest: guest)
        end
      end

      travel_to Time.new(0.year.from_now.year, 0.month.from_now.month, 2.days.from_now.day, 14, 0, 0) do
        bookings.each_value do |booking|
          booking[1].update!(check_in_confirmed_date: Date.today, check_in_confirmed_hour: Time.now)
          booking[1].active!
        end
      end

      travel_to Time.new(0.year.from_now.year, 0.month.from_now.month, 5.days.from_now.day, 12, 0, 0) do
        bookings.each_value do |booking|
          booking[1].finished!
          booking[1].update!(check_out_confirmed_date: Date.today, check_out_confirmed_hour: Time.now,
                               total_paid: booking[1].calculate_total_paid, payment_method: 'credit_card')
          booking[1].create_review!(rating: 1, comment: 'Não gostei', guest: guest)
        end
      end

      travel_to Time.new(0.year.from_now.year, 0.month.from_now.month, 5.days.from_now.day, 14, 0, 0) do
        bookings.each_value do |booking|
          booking[2].update!(check_in_confirmed_date: Date.today, check_in_confirmed_hour: Time.now)
          booking[2].active!
        end
      end

      travel_to Time.new(0.year.from_now.year, 0.month.from_now.month, 7.days.from_now.day, 12, 0, 0) do
        bookings.each_value do |booking|
          booking[2].finished!
          booking[2].update!(check_out_confirmed_date: Date.today, check_out_confirmed_hour: Time.now,
                               total_paid: booking[2].calculate_total_paid, payment_method: 'credit_card')
          booking[2].create_review!(rating: 3, comment: 'Bonzinho', guest: guest)
        end
      end

      travel_to Time.new(0.year.from_now.year, 0.month.from_now.month, 7.days.from_now.day, 14, 0, 0) do
        bookings.each_value do |booking|
          booking.last.update!(check_in_confirmed_date: Date.today, check_in_confirmed_hour: Time.now)
          booking.last.active!
        end
      end

      travel_to Time.new(0.year.from_now.year, 0.month.from_now.month, 10.days.from_now.day, 12, 0, 0) do
        bookings.each_value do |booking|
          booking.last.finished!
          booking.last.update!(check_out_confirmed_date: Date.today, check_out_confirmed_hour: Time.now,
                             total_paid: booking.last.calculate_total_paid, payment_method: 'credit_card')
          booking.last.create_review!(rating: 2, comment: 'Mais ou menos', guest: guest)
        end
      end

      # Act
      travel_to Time.new(0.year.from_now.year, 0.month.from_now.month, 10.days.from_now.day, 15, 0, 0) do
        visit root_path

        # Assert
        expect(page).to_not have_content('Nenhuma pousada cadastrada')
        expect(page).to have_content('Pousada Nascer do Sol')
        expect(page).to have_content('Itapetininga - SP')
        expect(page).to have_content('Nota: 3', count: 2)
        expect(page).to have_content('Pousada Praiana')
        expect(page).to have_content('Camboriú - SC')
      end
    end

    it 'sees a search bar' do
      # Arrange
      cities = %w[Itapetininga Sorocaba Sorocaba]
      states = %w[SP SP SP]
      guesthouses_names =
        %w[Nascer\ do\ Sol Lua\ Cheia Estrela\ Cadente]
      user_names = %w[Joao Maria Jose]
      guesthouse =  {
        0 => '', 1 => '', 2 => ''
      }
      user = {
        0 => '', 1 => '', 2 => ''
      }
      guesthouse_owner = {
        0 => '', 1 => '', 2 => ''
      }

      PaymentMethod.create!(method: 'credit_card')
      PaymentMethod.create!(method: 'debit_card')
      PaymentMethod.create!(method: 'pix')

      guesthouses_names.each_with_index do |name, index|
        user[index] = User.create!(name: user_names[index], email: "#{user_names[index].downcase}@email.com",
                                   password: 'password', role: 1)
        guesthouse_owner[index] = user[index].build_guesthouse_owner
        guesthouse[index] = guesthouse_owner[index]
                              .build_guesthouse(corporate_name: "#{name} LTDA.",
                                                brand_name: "Pousada #{name}",
                                                registration_code: "#{index}47032102000152",
                                                phone_number: "#{index}1598308183",
                                                email: "contato@#{name.downcase.gsub(" ", "")}.com.br",
                                                description: "Descrição da Pousada #{name}",
                                                pets: true,
                                                use_policy: 'Não é permitido fumar nas dependências da pousada',
                                                checkin_hour: '14:00', checkout_hour: '12:00',
                                                active: index == 2 ? false : true)

        guesthouse[index].build_address(street: "Avenida #{index}, #{index}000",
                                        neighborhood: "Bairro #{index}" ,
                                        city: cities[index], state: states[index],
                                        postal_code: "#{index}1001-000")

        guesthouse[index].payment_methods = PaymentMethod.all
        guesthouse[index].save!
      end
      # Act
      visit(root_path)

      # Assert
      expect(page).to have_select('city', with_options: %w[Selecione\ uma\ Cidade Itapetininga Sorocaba])
      expect(page).to have_button('Buscar')
    end
  end
end