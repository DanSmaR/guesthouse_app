require 'rails_helper'

describe 'User not logged in'
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