require 'rails_helper'

describe 'User edit guesthouse' do
  it 'shows the forms edit page' do
    # Arrange
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
    click_on 'Editar Pousada'

    # Assert
    expect(page).to have_content('Editar Pousada')
    expect(page).to have_field('Razão Social', with: 'Pousada Nascer do Sol LTDA.')
    expect(page).to have_field('Nome Fantasia', with: 'Pousada Nascer do Sol')
    expect(page).to have_field('CNPJ', with: '47032102000152')
    expect(page).to have_field('Telefone', with: '15983081833')
    expect(page).to have_field('E-mail', with: 'contato@nascerdosol.com.br')
    expect(page).to have_field('Logradouro', with: 'Rua das Flores, 1000')
    expect(page).to have_field('Bairro', with: 'Vila Belo Horizonte')
    expect(page).to have_field('Cidade', with: 'Itapetininga')
    expect(page).to have_select('Estado', with_options: ['SP'])
    expect(page).to have_field('CEP', with: '01001-000')
    expect(page).to have_field('Descrição', with: 'Pousada com vista linda para a serra')
    expect(page).to have_field('Aceita Pets', type: 'checkbox', checked: true)
    expect(page).to have_field('Política de Uso', with: 'Não é permitido fumar nas dependências da pousada')
    expect(page).to have_select('guesthouse_checkin_hour_4i', with_options: ['14'])
    expect(page).to have_select('guesthouse_checkin_hour_5i', with_options: ['00'])
    expect(page).to have_select('guesthouse_checkout_hour_4i', with_options: ['12'])
    expect(page).to have_select('guesthouse_checkout_hour_5i', with_options: ['00'])
    expect(page).to have_field('Cartão de crédito', type: 'checkbox', checked: false)
    expect(page).to have_field('Cartão de débito', type: 'checkbox', checked: false)
    expect(page).to have_field('Pix', type: 'checkbox', checked: false)
  end
end