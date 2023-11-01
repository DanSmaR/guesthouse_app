require 'rails_helper'

describe 'Guesthouse owner registers Guesthouse' do
  it 'successfully' do
    # Arrange
    user = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password', role: 1)
    GuesthouseOwner.create!(user: user)

    # Act
    login_as user
    visit root_path

    fill_in 'Razão Social', with: 'Pousada Nascer do Sol LTDA.'
    fill_in 'Nome Fantasia', with: 'Pousada Nascer do Sol'
    fill_in 'CNPJ', with: '47032102000152'
    fill_in 'Telefone', with: '15983081833'
    fill_in 'Email', with: 'contato@nascerdosol.com.br'
    fill_in 'Logradouro', with: 'Rua das Flores, 1000'
    fill_in 'Bairro', with: 'Vila Belo Horizonte'
    fill_in 'Cidade', with: 'Itapetininga'
    fill_in 'Estado', with: 'SP'
    fill_in 'CEP', with: '01001-000'
    fill_in 'Descrição', with: 'Pousada com vista linda para a serra'
    fill_in 'Política de uso', with: 'Não é permitido fumar nas dependências da pousada'
    fill_in 'Horário de checkin', with: '14:00'
    fill_in 'Horário de checkout', with: '12:00'
    check 'Aceita Pets'
    check 'Cartão de crédito'

    click_on 'Enviar'
  end
end