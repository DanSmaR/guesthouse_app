require  'rails_helper'

describe 'User signs up' do
  it 'successfully as Guesthouse Owner' do
    # Arrange

    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Registrar-se'
    fill_in 'Nome', with: 'Maria'
    fill_in 'E-mail', with: 'maria@email.com'
    select 'Proprietário de Pousada', from: 'Tipo de Usuário'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    # Assert
    expect(page).to have_content('Você precisa cadastrar uma pousada para continuar')
    expect(page).to have_content('maria@email.com')
    expect(page).to have_button('Sair')
    expect(User.last.name).to eq('Maria')
    expect(page).to have_content('Nova Pousada')
    expect(current_path).to eq(new_guesthouse_path)
  end
end