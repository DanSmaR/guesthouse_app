require 'rails_helper'

describe 'Guesthouse owner registers Guesthouse' do
  it 'successfully' do
    # Arrange
    user = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password', role: 1)
    user.create_guesthouse_owner!
    PaymentMethod.create!(method: 'credit_card')
    PaymentMethod.create!(method: 'debit_card')
    PaymentMethod.create!(method: 'pix')

    # Act
    login_as user
    visit root_path

    fill_in 'Razão Social', with: 'Pousada Nascer do Sol LTDA.'
    fill_in 'Nome Fantasia', with: 'Pousada Nascer do Sol'
    fill_in 'CNPJ', with: '47032102000152'
    fill_in 'Telefone', with: '15983081833'
    fill_in 'E-mail', with: 'contato@nascerdosol.com.br'
    fill_in 'Logradouro', with: 'Rua das Flores, 1000'
    fill_in 'Bairro', with: 'Vila Belo Horizonte'
    fill_in 'Cidade', with: 'Itapetininga'
    select 'SP', from: 'Estado'
    fill_in 'CEP', with: '01001-000'
    fill_in 'Descrição', with: 'Pousada com vista linda para a serra'
    fill_in 'Política de Uso', with: 'Não é permitido fumar nas dependências da pousada'
    select '14', from: 'guesthouse_checkin_hour_4i'
    select '00', from: 'guesthouse_checkin_hour_5i'
    select '12', from: 'guesthouse_checkout_hour_4i'
    select '00', from: 'guesthouse_checkout_hour_5i'
    check 'Aceita Pets'
    check 'Cartão de crédito'
    check 'Cartão de débito'
    check 'Pix'
    click_on 'Criar Pousada'

    # Assert
    expect(page).to have_content('Pousada Nascer do Sol')
    expect(page).to have_content('Itapetininga - SP')
    expect(page).to have_content('Pousada com vista linda para a serra')
    expect(page).to have_content('Não é permitido fumar nas dependências da pousada')
    expect(page).to have_content('14:00')
    expect(page).to have_content('12:00')
    expect(page).to have_content('Pets: Permitido')
    expect(page).to have_content('Cartão de crédito')
    expect(page).to have_content('Cartão de débito')
    expect(page).to have_content('Pix')
  end

  it 'and must fill in all fields' do
    # Arrange
    user = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password', role: 1)
    user.create_guesthouse_owner!
    PaymentMethod.create!(method: 'credit_card')
    PaymentMethod.create!(method: 'debit_card')
    PaymentMethod.create!(method: 'pix')

    # Act
    login_as user
    visit root_path

    fill_in 'Razão Social', with: ''
    fill_in 'Nome Fantasia', with: ''

    click_on 'Criar Pousada'

    # Assert
    expect(current_path).to eq(guesthouses_path)
    expect(page).to have_content('Pousada não cadastrada. Preencha todos os campos.')
  end
end