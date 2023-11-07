require 'rails_helper'

describe 'User gets authenticated' do
  it 'successfully as Guesthouse Owner' do
    # Arrange
    guesthouse_owner_role = 1
    User.create!(name: 'Joao', email: 'joao@email.com', password: 'password', role: guesthouse_owner_role)
    GuesthouseOwner.create!(user: User.last)

    # Act
    visit root_path
    click_on 'Entrar'
    # We must use within to specify the scope of the click_on method
    # because there are two buttons with the same name on the page
    # being one of them from the application layout and the other
    # this one from the login form
    fill_in 'E-mail', with: 'joao@email.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'

    # Assert
    expect(page).to have_button 'Sair'
    expect(page).not_to have_link 'Entrar'
    expect(page).to have_content 'joao@email.com'
    expect(page).to have_content('Login efetuado com sucesso. Por favor, cadastre uma pousada para continuar')
    expect(page).to have_button('Sair')
    expect(User.last.name).to eq('Joao')
    expect(page).to have_content('Nova Pousada')
    expect(current_path).to eq(new_guesthouse_path)
  end

  it 'and logs out' do
    # Arrange
    User.create!(name: 'Joao', email: 'joao@email.com', password: 'password', role: 1)
    GuesthouseOwner.create!(user: User.last)

    # Act
    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: 'joao@email.com'
    fill_in 'Senha', with: 'password'
    within 'form#new_user' do
      click_on 'Entrar'
    end
    click_on 'Sair'

    # Assert
    expect(page).to have_content('Logout efetuado com sucesso')
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'joao@email.com'
  end
end