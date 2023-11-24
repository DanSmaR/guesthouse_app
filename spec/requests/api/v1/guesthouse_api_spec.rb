require 'rails_helper'

describe 'Guesthouse API', type: :request do
  context 'GET /api/v1/guesthouses/1' do
    it 'returns a guesthouse' do
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
      get '/api/v1/guesthouses/1'

      # Assert
      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')

      parsed_body = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_body[:corporate_name]).to eq('Pousada Nascer do Sol LTDA.')
      expect(parsed_body[:brand_name]).to eq('Pousada Nascer do Sol')
      expect(parsed_body[:registration_code]).to eq('47032102000152')
      expect(parsed_body[:phone_number]).to eq('15983081833')
      expect(parsed_body[:email]).to eq('contato@nascerdosol.com.br')
      expect(parsed_body[:description]).to eq('Pousada com vista linda para a serra')
      expect(parsed_body[:pets]).to eq(true)
      expect(parsed_body[:use_policy]).to eq('Não é permitido fumar nas dependências da pousada')
      expect(parsed_body[:checkin_hour]).to eq('14:00')
      expect(parsed_body[:checkout_hour]).to eq('12:00')
      expect(parsed_body[:active]).to eq(true)
      expect(parsed_body[:address][:street]).to eq('Rua das Flores, 1000')
      expect(parsed_body[:address][:neighborhood]).to eq('Vila Belo Horizonte')
      expect(parsed_body[:address][:city]).to eq('Itapetininga')
      expect(parsed_body[:address][:state]).to eq('SP')
      expect(parsed_body[:address][:postal_code]).to eq('01001-000')
      expect(parsed_body[:payment_methods][0][:method]).to eq('credit_card')
      expect(parsed_body[:payment_methods][1][:method]).to eq('debit_card')
      expect(parsed_body[:payment_methods][2][:method]).to eq('pix')
      expect(parsed_body.keys).to_not include(:created_at)
      expect(parsed_body.keys).to_not include(:updated_at)
    end
  end
end