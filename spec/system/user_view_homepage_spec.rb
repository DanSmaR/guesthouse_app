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
      end
      expect(page).to have_content('Sejam bem vindos(as) ao Pousada App')
    end

    it 'should see some guesthouses' do
      # Arrange
      cities = %w[Itapetininga Sorocaba São\ Paulo Rio\ de\ Janeiro Belo\ Horizonte Sorocaba]
      states = %w[SP SP SP RJ MG SP]
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
        guesthouse[index] = guesthouse_owner[index].build_guesthouse(corporate_name: "#{name} LTDA.",
        brand_name: "Pousada #{name}",
        registration_code: "#{index}47032102000152",
        phone_number: "#{index}1598308183",
        email: "contato@#{name.downcase.gsub(" ", "")}.com.br", description: "Descrição da Pousada #{name}",
        pets: true, use_policy: 'Não é permitido fumar nas dependências da pousada',
        checkin_hour: '14:00', checkout_hour: '12:00', active: index == 2 ? false : true)

        guesthouse[index].build_address(street: "Rua das Flores, #{index}000",
                                        neighborhood: 'Vila Belo Horizonte' ,
        city: cities[index], state: states[index], postal_code: "#{index}1001-000")

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

      # Assert
      expect(page).to_not have_content('Nenhuma pousada cadastrada')
      # last 3 active guesthouses
      within 'section#last3_guesthouses' do
        expect(page).to have_content('Pousada Vista Linda')
        expect(page).to have_content('Sorocaba')
        expect(page).to have_content('Pousada Alto do Mirante')
        expect(page).to have_content('Belo Horizonte')
        expect(page).to have_content('Pousada Lago Verde')
        expect(page).to have_content('Rio de Janeiro')
        expect(page).to_not have_content('Pousada Estrela Cadente')
        expect(page).to_not have_content('Pousada Lua Cheia')
        expect(page).to_not have_content('Pousada Nascer do Sol')
      end
      # show the remaining active guesthouses out of the div#last_guesthouses
      within 'section#remaining_guesthouses' do
        expect(page).to have_content('Pousada Lua Cheia')
        expect(page).to have_content('Sorocaba')
        expect(page).to have_content('Pousada Nascer do Sol')
        expect(page).to have_content('Itapetininga')
        expect(page).to_not have_content('Pousada Estrela Cadente')
        expect(page).to_not have_content('São Paulo')
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
      within 'header' do
        expect(page).to have_select('city', with_options: %w[Selecione\ uma\ Cidade Itapetininga Sorocaba])
        expect(page).to have_button('Buscar')
      end
    end
  end
end