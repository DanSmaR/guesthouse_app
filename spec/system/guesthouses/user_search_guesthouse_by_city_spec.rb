require 'rails_helper'

describe 'User search guesthouse by city' do
  context 'when not logged in' do
    it 'successfully' do
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
                                                active: true)

        guesthouse[index].build_address(street: "Avenida #{index}, #{index}000",
                                        neighborhood: "Bairro #{index}" ,
                                        city: cities[index], state: states[index],
                                        postal_code: "#{index}1001-000")

        guesthouse[index].payment_methods = PaymentMethod.all
        guesthouse[index].save!
      end

      # Act
      visit(root_path)
      select 'Sorocaba', from: 'Buscar por Cidade'
      click_on 'Buscar'

      # Assert
      expect(current_path).to eq(search_guesthouses_path)
      expect(page).to have_content('Resultados da Busca por: Sorocaba')
      expect(page).to have_content('2 pousadas encontradas')
      # Assert the guesthouses are sorted by brand_name
      %w[Estrela\ Cadente Lua\ Cheia].each_with_index do |guesthouse, index|
        expect(page).to have_selector(
                          "dl:nth-child(#{index + 3}) > dt > h4 > a",
                          text: "Pousada #{guesthouse}")
      end
    end

    it 'and does not get any results' do
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
      click_on 'Buscar'

      # Assert
      expect(current_path).to eq(root_path)
      expect(page).to have_content('Termo para busca está vazio')
    end
  end
end