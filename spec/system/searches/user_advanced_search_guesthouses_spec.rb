require 'rails_helper'

describe 'User does advanced search' do
  it 'visit the advanced search page' do
    # Arrange
    # Act
    visit(root_path)
    click_on('Pesquisa Avançada')

    # Assert
    expect(page).to have_content('Pesquisa Avançada de Pousadas')
    expect(page).to have_field('Digite o nome, bairro ou cidade')
    expect(page).to have_unchecked_field('Aceita Pets')
    expect(page).to have_unchecked_field('Acessível para PCDs')
    expect(page).to have_unchecked_field('Ar condicionado no quarto')
    expect(page).to have_unchecked_field('TV no quarto')
    expect(page).to have_button('Buscar')
  end
  it 'successfully' do
    # Arrange
    cities = %w[Itapetininga Sorocaba São\ Paulo Rio\ de\ Janeiro Belo\ Horizonte Sorocaba]
    states = %w[SP SP SP RJ MG SP]
    guesthouses_names =
      %w[Nascer\ do\ Sol Lua\ Cheia Estrela\ Cadente Lago\ Verde Raio\ de\ Sol Vista\ Linda]
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
                                                                   email: "contato@#{name.downcase.gsub(" ", "")}.com.br",
                                                                   description: "Descrição da Pousada #{name}",
                                                                   pets: index.odd? ? true : false,
                                                                   use_policy: 'Não é permitido fumar nas dependências da pousada',
                                                                   checkin_hour: '14:00', checkout_hour: '12:00',
                                                                   active: index == 2 ? false : true)

      guesthouse[index].build_address(street: index.odd? ? "Rua #{index},  #{index}000" : "Avenida #{index}, #{index}000",
                                      neighborhood: index.even? ? "Bairro #{index}" : "Centro #{index}",
                                      city: cities[index], state: states[index], postal_code: "#{index}1001-000")

      guesthouse[index].payment_methods = PaymentMethod.all
      guesthouse[index].save!

      guesthouse[index].rooms.create!([{ name: "Quarto Primavera #{index}",
                                         description: 'Quarto com vista para a serra',
                                         size: 30, max_people: 2, daily_rate: 100,
                                         bathroom: true, balcony: true,
                                         air_conditioning: index.even? ? true : false,
                                         tv: index.odd? ? true : false, wardrobe: true,
                                         safe: true, accessible: index.even? ? true : false,
                                         available: true },
                                       { name: "Quarto Verão #{index}",
                                         description: 'Quarto com vista para o mar',
                                         size: 30, max_people: 2, daily_rate: 100,
                                         bathroom: true, balcony: true,
                                         air_conditioning: index == 1 ? false : true,
                                         tv: index == 1 ? false : true, wardrobe: true,
                                         safe: true, accessible: index == 0 ? false : true,
                                         available: index.odd? ? true : false }])
      guesthouse[index].rooms.first&.room_rates&.create!([{ start_date: '2021-01-01',
                                                            end_date: '2021-01-31',
                                                            daily_rate: (index + 2) * 100 },
                                                          { start_date: '2021-02-01',
                                                            end_date: '2021-02-28',
                                                            daily_rate: (index + 1) * 100 }])
    end

    # Arrange
    cities2 = %w[Ouro\ Preto Camboriu]
    states2 = %w[MG SC]
    guesthouses_names2 =
      %w[Serrana Praiana]
    user_names2 = %w[Cesar Simone]
    guesthouse2 =  {
      0 => '', 1 => ''
    }
    user2 = {
      0 => '', 1 => ''
    }
    guesthouse_owner2 = {
      0 => '', 1 => ''
    }

    guesthouses_names2.each_with_index do |name, index|
      user2[index] = User.create!(name: user_names2[index], email: "#{user_names2[index].downcase}@email.com",
                                 password: 'password', role: 1)
      guesthouse_owner2[index] = user2[index].build_guesthouse_owner
      guesthouse2[index] = guesthouse_owner2[index].build_guesthouse(corporate_name: "#{name} LTDA.",
                                                                   brand_name: "Pousada #{name}",
                                                                   registration_code: "#{index}47032102000152",
                                                                   phone_number: "#{index}1598308183",
                                                                   email: "contato@#{name.downcase.gsub(" ", "")}.com.br",
                                                                   description: "Descrição da Pousada #{name}",
                                                                   pets: index.odd? ? true : false,
                                                                   use_policy: 'Não é permitido fumar nas dependências da pousada',
                                                                   checkin_hour: '14:00', checkout_hour: '12:00',
                                                                   active: true)

      guesthouse2[index].build_address(street: index.odd? ? "Rua #{index},  #{index}000" : "Avenida #{index}, #{index}000",
                                      neighborhood: index.even? ? "Bairro #{index}" : "Centro #{index}",
                                      city: cities2[index], state: states2[index], postal_code: "#{index}1001-000")

      guesthouse2[index].payment_methods = PaymentMethod.all
      guesthouse2[index].save!

      guesthouse2[index].rooms.create!([{ name: "Quarto Aquarela #{index}",
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
      guesthouse2[index].rooms.first&.room_rates&.create!([{ start_date: '2021-01-01',
                                                            end_date: '2021-01-31',
                                                            daily_rate: (index + 2) * 100 },
                                                          { start_date: '2021-02-01',
                                                            end_date: '2021-02-28',
                                                            daily_rate: (index + 1) * 100 }])
    end

    # Act
    visit(root_path)
    click_on('Pesquisa Avançada')
    fill_in('Digite o nome, bairro ou cidade', with: 'Sor')
    check('Aceita Pets')
    check('TV no quarto')
    click_on('Buscar')

    # Assert
    expect(page).to have_content('Resultados da Busca por:')
    expect(page).to have_content('2 pousadas encontradas')
    expect(page).to have_content('Pousada Lua Cheia')
    expect(page).to have_content('Sorocaba - SP', count: 2)
    expect(page).to have_content('Pousada Vista Linda')
    expect(page).to_not have_content('Pousada Nascer do Sol')
    expect(page).to_not have_content('Pousada Estrela Cadente')
    expect(page).to_not have_content('Pousada Lago Verde')
    expect(page).to_not have_content('Pousada Raio de Sol')
  end
end