require 'rails_helper'

describe 'Room update' do
  it 'shows the update form' do
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
    guesthouse.rooms.create!([{ name: 'Quarto Primavera', description: 'Quarto com vista para a serra', size: 30,
                                max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                                air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                available: true },
                              { name: 'Quarto Verão', description: 'Quarto com vista para o mar', size: 30,
                                max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                                air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                available: false }])


    # Act
    login_as(user)
    visit root_path
    click_on 'Pousada Nascer do Sol'
    click_on 'Quartos'
    click_on 'Quarto Primavera'
    click_on 'Editar Quarto'

    # Assert
    expect(page).to have_content('Editar Quarto')
    expect(page).to have_field('Nome', with: 'Quarto Primavera')
    expect(page).to have_field('Descrição', with: 'Quarto com vista para a serra')
    expect(page).to have_field('Tamanho', with: 30)
    expect(page).to have_field('Acomodação máxima', with: 2)
    expect(page).to have_field('Valor da diária', with: 100.0)
    expect(page).to have_field('Banheiro', checked: true)
    expect(page).to have_field('Varanda', checked: true)
    expect(page).to have_field('Ar condicionado', checked: true)
    expect(page).to have_field('TV', checked: true)
    expect(page).to have_field('Guarda-roupa', checked: true)
    expect(page).to have_field('Cofre', checked: true)
    expect(page).to have_field('Acessível para PCDs', checked: true)
    expect(page).to have_field('Disponível', checked: true)
    expect(page).to have_button('Atualizar Quarto')
  end

  it 'successfully updates a room' do
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
    guesthouse.rooms.create!([{ name: 'Quarto Primavera', description: 'Quarto com vista para a serra', size: 30,
                                max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                                air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                available: true },
                              { name: 'Quarto Verão', description: 'Quarto com vista para o mar', size: 30,
                                max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                                air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                available: false }])


    # Act
    login_as(user)
    visit root_path
    click_on 'Pousada Nascer do Sol'
    click_on 'Quartos'
    click_on 'Quarto Primavera'
    click_on 'Editar Quarto'
    fill_in 'Nome', with: 'Quarto Outono'
    fill_in 'Descrição', with: 'Quarto com vista para a floresta'
    uncheck 'Banheiro'
    uncheck 'Varanda'

    click_on 'Atualizar Quarto'

    # Assert
    expect(page).to have_content('Quarto Outono')
    expect(page).to have_content('Quarto com vista para a floresta')
    expect(page).to have_content('Banheiro: Não')
    expect(page).to have_content('Varanda: Não')
    expect(page).to have_content('Quarto atualizado com sucesso')
  end

  # TODO - create a test which a user cannot access the room edition by typing the url, edit and update actions
end