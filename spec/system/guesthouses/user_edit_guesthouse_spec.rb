require 'rails_helper'

describe 'User edit guesthouse' do
  it 'shows the forms edit page' do
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
    expect(page).to have_field('Cartão de crédito', type: 'checkbox')
    expect(page).to have_field('Cartão de débito', type: 'checkbox')
    expect(page).to have_field('Pix', type: 'checkbox')
  end

  it 'successfully edits a guesthouse' do
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
    fill_in 'Nome Fantasia', with: 'Pousada Pôr do Sol'
    fill_in 'Descrição', with: 'Pousada com vista linda para o pôr do sol'
    click_on 'Atualizar Pousada'

    # Assert
    expect(page).to have_content('Pousada Pôr do Sol')
    expect(page).to have_content('Pousada com vista linda para o pôr do sol')
    expect(page).to have_content('Pousada atualizada com sucesso')
  end

  it 'cannot edit a guesthouse if it is not the owner' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 1)
    user2 = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password', role: 1)

    guesthouse_owner2 = user2.build_guesthouse_owner
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

    guesthouse2 = guesthouse_owner2.build_guesthouse(corporate_name: 'Casa do Saber LTDA.',
                                                   brand_name: 'Casa do Saber',
                                                   registration_code: '47032102000152',
                                                   phone_number: '15983081833',
                                                   email: 'contato@casadosaber.com.br',
                                                   description: 'Pousada com muito conhecimeto',
                                                   pets: true,
                                                   use_policy: 'Não é permitido fumar nas dependências da pousada',
                                                   checkin_hour: '14:00', checkout_hour: '12:00', active: true)
    guesthouse2.build_address(street: 'Rua da Sucata, 1000', neighborhood: 'Vila Minas Gerais' ,
                             city: 'Itapevi', state: 'SP', postal_code: '01001-000')

    guesthouse2.payment_methods = PaymentMethod.all

    guesthouse.save!
    guesthouse2.save!

    # Act
    login_as(user2)
    visit root_path
    click_on 'Pousada Nascer do Sol'

    # Assert
    expect(page).not_to have_link('Editar Pousada')
  end

  it 'does not update a guesthouse if its fields are empty' do
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
    fill_in 'Nome Fantasia', with: ''
    fill_in 'Descrição', with: ''
    click_on 'Atualizar Pousada'

    # Assert
    expect(page).to have_content('Pousada não atualizada. Preencha todos os campos.')
  end

  #   TODO - create a test which a user cannot access the guesthouse edition by typing the url, edit and update actions
end