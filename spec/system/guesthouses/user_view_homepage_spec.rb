require 'rails_helper'

describe 'User landing in the home page' do
  it 'should see the app name' do
    # Arrange
    # Act
    visit('/')

    # Assert
    expect(page).to have_content('Pousada App')
  end

  it 'should see the guesthouse descriptions' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    guesthouse_owner = GuesthouseOwner.create!(user: user)
    address = Address.create!(street: 'Rua das Flores, 1000', neighborhood: 'Vila Belo Horizonte' ,
                              city: 'Itapetininga', state: 'SP', cep: '01001-000')
    Guesthouse.create!(corporate_name: 'Pousada Nascer do Sol LTDA.',
                                    brand_name: 'Pousada Nascer do Sol',
                                    registration_code: '47032102000152',
                                    phone_number: '15983081833',
                                    email: 'contato@nascerdosol.com.br', address: address,
                                    user: user, description: 'Pousada com vista linda para a serra',
                                    payment_method: 'Cartão de Crédito', pets: true,
                                    use_policy: 'Não é permitido fumar nas dependências da pousada',
                                    checkin_hour: '14:00', checkout_hour: '12:00', active: true)
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