require 'rails_helper'

describe 'User sees search bar' do
  context 'when not logged in' do
    it 'in home page' do
      # Arrange
      # Act
      visit(root_path)

      # Assert
      within 'header' do
        expect(page).to have_field('Pesquisar Pousadas')
        expect(page).to have_button('Pesquisar')
      end
    end

    it 'in log in page' do
      # Arrange

      # Act
      visit(new_user_session_path)

      # Assert
      within 'header' do
        expect(page).to have_field('Pesquisar Pousadas')
        expect(page).to have_button('Pesquisar')
      end
    end

    it 'in sign up page' do
      # Arrange

      # Act
      visit(new_user_registration_path)

      # Assert
      within 'header' do
        expect(page).to have_field('Pesquisar Pousadas')
        expect(page).to have_button('Pesquisar')
      end
    end

    it 'in guesthouses details page' do
      # Arrange
      cities = %w[Itapetininga]
      states = %w[SP]
      guesthouses_names =
        %w[Nascer\ do\ Sol]
      user_names = %w[Joao]
      guesthouse =  {
        0 => ''
      }
      user = {
        0 => ''
      }
      guesthouse_owner = {
        0 => ''
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
      visit(guesthouse_path(guesthouse[0]))

      # Assert
      within 'header' do
        expect(page).to have_field('Pesquisar Pousadas')
        expect(page).to have_button('Pesquisar')
      end
    end

    it 'in rooms details page' do
      # Arrange
      cities = %w[Itapetininga]
      states = %w[SP]
      guesthouses_names =
        %w[Nascer\ do\ Sol]
      user_names = %w[Joao]
      guesthouse =  {
        0 => ''
      }
      user = {
        0 => ''
      }
      guesthouse_owner = {
        0 => ''
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
      end

      # Act
      visit(guesthouse_room_path(guesthouse[0], guesthouse[0].rooms.first))

      # Assert
      within 'header' do
        expect(page).to have_field('Pesquisar Pousadas')
        expect(page).to have_button('Pesquisar')
      end
    end
  end
end

describe 'User searches for a guesthouse' do
  context 'when not logged in' do
    it 'successfully by name' do
      # Arrange
      cities = %w[Itapetininga Sorocaba Sorocaba]
      states = %w[SP SP SP]
      guesthouses_names =
        %w[Lua\ Cheia Raio\ de\ Sol Nascer\ do\ Sol]
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
      fill_in 'Pesquisar Pousadas', with: 'Sol'
      click_on 'Pesquisar'

      # Assert
      expect(current_path).to eq(guesthouses_general_searches_path)
      expect(page).to have_content('Resultados da Busca por: Sol')
      expect(page).to have_content('1 pousada encontrada')
      # Assert the guesthouses are sorted by brand_name
      %w[Raio\ de\ Sol].each_with_index do |guesthouse, index|
        expect(page).to have_selector(
                          "dl:nth-child(#{index + 3}) > dt > h4 > a",
                          text: "Pousada #{guesthouse}")
      end
    end

    it 'successfully by neighborhood' do
      # Arrange
      cities = %w[Itapetininga Sorocaba Sorocaba]
      states = %w[SP SP SP]
      guesthouses_names =
        %w[Lua\ Cheia Raio\ de\ Sol Nascer\ do\ Sol]
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
                                        neighborhood: index.even? ? "Bairro #{index}" : "Vila #{index}" ,
                                        city: cities[index], state: states[index],
                                        postal_code: "#{index}1001-000")

        guesthouse[index].payment_methods = PaymentMethod.all
        guesthouse[index].save!
      end

      # Act
      visit(root_path)
      fill_in 'Pesquisar Pousadas', with: 'Bairro'
      click_on 'Pesquisar'

      # Assert
      expect(current_path).to eq(guesthouses_general_searches_path)
      expect(page).to have_content('Resultados da Busca por: Bairro')
      expect(page).to have_content('1 pousada encontrada')
      # Assert the guesthouses are sorted by brand_name
      %w[Lua\ Cheia].each_with_index do |guesthouse, index|
        expect(page).to have_selector(
                          "dl:nth-child(#{index + 3}) > dt > h4 > a",
                          text: "Pousada #{guesthouse}")
      end
    end

    it 'successfully by city' do
      # Arrange
      cities = %w[Itapetininga Sorocaba Sorocaba]
      states = %w[SP SP SP]
      guesthouses_names =
        %w[Lua\ Cheia Raio\ de\ Sol Nascer\ do\ Sol]
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
      fill_in 'Pesquisar Pousadas', with: 'Sorocaba'
      click_on 'Pesquisar'

      # Assert
      expect(current_path).to eq(guesthouses_general_searches_path)
      expect(page).to have_content('Resultados da Busca por: Sorocaba')
      expect(page).to have_content('1 pousada encontrada')
      # Assert the guesthouses are sorted by brand_name
      %w[Raio\ de\ Sol].each_with_index do |guesthouse, index|
        expect(page).to have_selector(
                          "dl:nth-child(#{index + 3}) > dt > h4 > a",
                          text: "Pousada #{guesthouse}")
      end
    end

    it 'unsuccessfully' do
      # Arrange
      # Act
      visit(root_path)
      fill_in 'Pesquisar Pousadas', with: ''
      click_on 'Pesquisar'

      # Assert
      expect(current_path).to eq(root_path)
      expect(page).to have_content('Termo para pesquisa está vazio')
    end
  end
end