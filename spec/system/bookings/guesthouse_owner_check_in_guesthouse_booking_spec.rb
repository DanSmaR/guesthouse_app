require 'rails_helper'

describe 'Guesthouse owner check in booking' do
  it 'successfully' do
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
      guesthouse[index].rooms.first&.bookings&.create!([{check_in_date: 2.days.from_now, check_out_date: 4.days.from_now,
                                                     number_of_guests: 2, guest: guest, total_price: 200, status: 0,
                                                     check_in_hour: '14:00', check_out_hour: '12:00',
                                                     reservation_code: "#{index}A123AC1"},
                                                    {check_in_date: 4.days.from_now, check_out_date: 5.days.from_now,
                                                     number_of_guests: 2, guest: guest, total_price: 100, status: 0,
                                                     check_in_hour: '14:00', check_out_hour: '12:00',
                                                     reservation_code: "#{index}B123AC1"}])
    end


    # Act
    login_as user[0], scope: :user
    visit guesthouse_owner_bookings_path
    click_on 'Check-In', match: :first

    # Assert
    expect(current_path).to eq(booking_path(guesthouse[0].rooms.first&.bookings&.first))
    expect(page).to have_content('Check-in realizado com sucesso')
    expect(page).to have_content('Situação: ativa')
    expect(page).to have_content('Dados de confirmação do check-in')
    expect(page).to have_content('Data de check-in confirmada: ' + guesthouse[0].rooms.first&.bookings&.first.check_in_confirmation_date.strftime('%d/%m/%Y'))
    expect(page).to have_content('Hora de check-in confirmada: ' + guesthouse[0].rooms.first&.bookings&.first.check_in_confirmation_hour.strftime('%H:%M'))
  end
end