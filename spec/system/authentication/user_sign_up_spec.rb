require  'rails_helper'

describe 'User signs up' do
  it 'successfully' do
    # Arrange

    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Registrar-se'
    fill_in 'Nome', with: 'Maria'
    fill_in 'E-mail', with: 'maria@email.com'
    select 'Proprietário de Pousada', from: 'Role'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    # Assert
    expect(page).to have_content('Boas vindas! Você realizou seu registro com sucesso.')
    expect(page).to have_content('maria@email.com')
    expect(page).to have_button('Sair')
    expect(User.last.name).to eq('Maria')
  end

  it 'as Guesthouse Owner' do
    # Arrange

    # Act
    visit new_user_registration_path
    fill_in 'E-mail', with: 'maria@email.com'
    select 'Proprietário de Pousada', from: 'Role'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    # Assert
    expect(current_path).to eq(new_guesthouse_path)
  end
end