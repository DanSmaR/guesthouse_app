require 'rails_helper'

describe 'User registers room' do
  it 'successfully' do
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
    login_as(user)
    visit root_path
    click_on 'Pousada Nascer do Sol'
    click_on 'Cadastrar Quarto'

    fill_in 'Nome', with: 'Quarto 1'
    fill_in 'Descrição', with: 'Quarto com vista para a serra'
    fill_in 'Tamanho', with: 30
    fill_in 'Acomodação máxima', with: 2
    fill_in 'Valor da diária', with: 100
    check 'Banheiro'
    check 'Varanda'
    check 'Ar condicionado'
    check 'TV'
    check 'Guarda-roupa'
    check 'Cofre'
    check 'Acessível para PCDs'

    click_on 'Criar Quarto'

    # Assert
    expect(current_path).to eq(guesthouse_room_path(guesthouse, 1))
    expect(page).to have_content('Quarto 1')
    expect(page).to have_content('Quarto com vista para a serra')
    expect(page).to have_content('Tamanho: 30 m')
    expect(page).to have_content('Acomodação Máxima: 2')
    expect(page).to have_content('Valor da Diária: R$ 100,00')
    expect(page).to have_content('Banheiro: Sim')
    expect(page).to have_content('Varanda: Sim')
    expect(page).to have_content('Ar Condicionado: Sim')
    expect(page).to have_content('TV: Sim')
    expect(page).to have_content('Guarda-roupa: Sim')
    expect(page).to have_content('Cofre: Sim')
    expect(page).to have_content('Acessível para PCDs: Sim')
    expect(page).to have_content('Disponibilidade: Sim')
  end

  it 'and must fill in all fields' do
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
    login_as(user)
    visit root_path
    click_on 'Pousada Nascer do Sol'
    click_on 'Cadastrar Quarto'

    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Tamanho', with: ''

    click_on 'Criar Quarto'

    # Assert
    expect(page).to have_content('Não foi possível cadastrar o quarto')
  end

  # TODO - create a test which a user cannot access the room creation by typing the url, new and create actions
end