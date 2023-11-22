require 'rails_helper'

describe 'User not logged in' do
  context 'when clicking on one of guesthouse last 3 section' do
    it 'sees the guesthouse details' do
      # Arrange
      cities = %w[Itapetininga Sorocaba São\ Paulo Rio\ de\ Janeiro Belo\ Horizonte Santa\ Catarina]
      states = %w[SP SP SP RJ MG SC]
      guesthouses_names =
        %w[Nascer\ do\ Sol Lua\ Cheia Estrela\ Cadente Lago\ Verde Alto\ do\ Mirante Vista\ Linda]
      user_names = %w[Joao Maria Jose Pedro Ana Paulo]
      guesthouse =  {
        0 => '', 1 => '', 2 => '', 3 => '', 4 => '', 5 => ''
      }
      user = {
        0 => '', 1 => '', 2 => '', 3 => '', 4 => '', 5 => ''
      }
      guesthouse_owner = {
        0 => '', 1 => '', 2 => '', 3 => '', 4 => '', 5 => ''
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

        guesthouse[index].rooms.create!([{ name: 'Quarto Primavera',
                                           description: 'Quarto com vista para a serra',
                                           size: 30, max_people: 2, daily_rate: 100,
                                           bathroom: true, balcony: true,
                                           air_conditioning: true, tv: true, wardrobe: true,
                                           safe: true, accessible: true,
                                           available: index.odd? ? true : false },
                                         { name: 'Quarto Verão',
                                           description: 'Quarto com vista para o mar',
                                           size: 30, max_people: 2, daily_rate: 100,
                                           bathroom: true, balcony: true,
                                           air_conditioning: true, tv: true, wardrobe: true,
                                           safe: true, accessible: true,
                                           available: index.even? ? true : false }])
        guesthouse[index].rooms.first&.room_rates&.create!([{ start_date: '2021-01-01',
                                                              end_date: '2021-01-31',
                                                              daily_rate: (index + 2) * 100 },
                                                            { start_date: '2021-02-01',
                                                              end_date: '2021-02-28',
                                                              daily_rate: (index + 1) * 100 }])
      end

      # Act
      visit(root_path)
      within('section#last3_guesthouses') do
        click_on('Pousada Vista Linda')
      end

      # Assert
      expect(page).to have_content(guesthouse[5].brand_name)
      expect(page).to have_content(guesthouse[5].description)
      expect(page).to have_content(guesthouse[5].address.street)
      expect(page).to have_content(guesthouse[5].address.neighborhood)
      expect(page).to have_content(guesthouse[5].address.city)
      expect(page).to have_content(guesthouse[5].address.state)
      expect(page).to have_content(guesthouse[5].address.postal_code)
      expect(page).to have_content(guesthouse[5].phone_number)
      expect(page).to have_content(guesthouse[5].email)
      expect(page).to have_content(guesthouse[5].use_policy)
      expect(page).to have_content(guesthouse[5].checkin_hour.strftime("%H:%M"))
      expect(page).to have_content(guesthouse[5].checkout_hour.strftime("%H:%M"))
      expect(page).to have_content('Cartão de crédito')
      expect(page).to have_content('Cartão de débito')
      expect(page).to have_content('Pix')
    end

    it 'sees last 3 ratings and comments' do
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

        click_on 'Pousada Nascer do Sol'

        # Assert
        expect(page).to have_link('Ver todas as avaliações')
        expect(page).to have_content('Algumas Avaliações')
        expect(page).to have_content('Hóspede: Maria', count: 3)
        expect(page).to_not have_content('Muito boa pousada')
        expect(page).to_not have_content('Nota: 5')
        expect(page).to have_content('Não gostei')
        expect(page).to have_content('Nota: Ruim - 1')
        expect(page).to have_content('Bonzinho')
        expect(page).to have_content('Nota: Bom - 3')
        expect(page).to have_content('Mais ou menos')
        expect(page).to have_content('Nota: Regular - 2')
      end
    end
  end

  context 'when clicking on one of guesthouse remaining section' do
    it 'sees the guesthouse details' do
      # Arrange
      cities = %w[Itapetininga Sorocaba São\ Paulo Rio\ de\ Janeiro Belo\ Horizonte Santa\ Catarina]
      states = %w[SP SP SP RJ MG SC]
      guesthouses_names =
        %w[Nascer\ do\ Sol Lua\ Cheia Estrela\ Cadente Lago\ Verde Alto\ do\ Mirante Vista\ Linda]
      user_names = %w[Joao Maria Jose Pedro Ana Paulo]
      guesthouse =  {
        0 => '', 1 => '', 2 => '', 3 => '', 4 => '', 5 => ''
      }
      user = {
        0 => '', 1 => '', 2 => '', 3 => '', 4 => '', 5 => ''
      }
      guesthouse_owner = {
        0 => '', 1 => '', 2 => '', 3 => '', 4 => '', 5 => ''
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
      within('section#remaining_guesthouses') do
        click_on('Pousada Lua Cheia')
      end

      # Assert
      expect(page).to have_content(guesthouse[1].brand_name)
      expect(page).to have_content(guesthouse[1].description)
      expect(page).to have_content(guesthouse[1].address.street)
      expect(page).to have_content(guesthouse[1].address.neighborhood)
      expect(page).to have_content(guesthouse[1].address.city)
      expect(page).to have_content(guesthouse[1].address.state)
      expect(page).to have_content(guesthouse[1].address.postal_code)
      expect(page).to have_content(guesthouse[1].phone_number)
      expect(page).to have_content(guesthouse[1].email)
      expect(page).to have_content(guesthouse[1].use_policy)
      expect(page).to have_content(guesthouse[1].checkin_hour.strftime("%H:%M"))
      expect(page).to have_content(guesthouse[1].checkout_hour.strftime("%H:%M"))
      expect(page).to have_content('Cartão de crédito')
      expect(page).to have_content('Cartão de débito')
      expect(page).to have_content('Pix')
    end
  end
end

describe 'User logged in' do
  it 'sees last 3 ratings and comments' do
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
      login_as(user3, scope: :user)
      visit root_path

      click_on 'Pousada Nascer do Sol'

      # Assert
      expect(page).to have_content('maria@email.com')
      expect(page).to have_link('Ver todas as avaliações')
      expect(page).to have_content('Algumas Avaliações')
      expect(page).to have_content('Hóspede: Maria', count: 3)
      expect(page).to_not have_content('Muito boa pousada')
      expect(page).to_not have_content('Nota: 5')
      expect(page).to have_content('Não gostei')
      expect(page).to have_content('Nota: Ruim - 1')
      expect(page).to have_content('Bonzinho')
      expect(page).to have_content('Nota: Bom - 3')
      expect(page).to have_content('Mais ou menos')
      expect(page).to have_content('Nota: Regular - 2')
    end
  end
end