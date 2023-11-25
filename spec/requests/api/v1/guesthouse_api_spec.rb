require 'rails_helper'

describe 'Guesthouse API', type: :request do
  context 'GET /api/v1/guesthouses' do
    it 'returns a list of active guesthouses' do
      # Arrange
      cities = %w[Itapetininga Sorocaba Camboriú]
      states = %w[SP SP SC]
      guesthouses_names = %w[Nascer\ do\ Sol Sorocabana Praiana]
      user_names = %w[Joao Marlene Cesar]
      guesthouse =  {
        0 => '', 1 => ''
      }
      user = {
        0 => '', 1 => ''
      }
      guesthouse_owner = {
        0 => '', 1 => ''
      }

      PaymentMethod.create!(method: 'credit_card')
      PaymentMethod.create!(method: 'debit_card')
      PaymentMethod.create!(method: 'pix')

      guesthouses_names.each_with_index do |name, index|
        user[index] = User.create!(name: user_names[index], email: "#{user_names[index].downcase}@email.com",
                                   password: 'password', role: 1)
        guesthouse_owner[index] = user[index].build_guesthouse_owner
        guesthouse[index] = guesthouse_owner[index].build_guesthouse(corporate_name: "#{name} LTDA.",
                                                                     brand_name: "Pousada #{name}",
                                                                     registration_code: "#{index}47032102000152",
                                                                     phone_number: "#{index}1598308183",
                                                                     email: "contato@#{name.downcase.gsub(" ", "")}.com.br",
                                                                     description: "Descrição da Pousada #{name}",
                                                                     pets: index.odd? ? true : false,
                                                                     use_policy: 'Não é permitido fumar nas dependências da pousada',
                                                                     checkin_hour: '14:00', checkout_hour: '12:00',
                                                                     active: index.even? ? true : false)

        guesthouse[index].build_address(street: index.odd? ? "Rua #{index},  #{index}000" : "Avenida #{index}, #{index}000",
                                        neighborhood: index.even? ? "Bairro #{index}" : "Centro #{index}",
                                        city: cities[index], state: states[index], postal_code: "#{index}1001-000")

        guesthouse[index].payment_methods = PaymentMethod.all
        guesthouse[index].save!
      end

      # Act
      get '/api/v1/guesthouses'

      # Assert
      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')

      parsed_body = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_body.size).to eq(2)
      expect(parsed_body[0][:corporate_name]).to eq nil
      expect(parsed_body[0][:brand_name]).to eq('Pousada Nascer do Sol')
      expect(parsed_body[0][:registration_code]).to eq nil
      expect(parsed_body[0][:phone_number]).to eq('01598308183')
      expect(parsed_body[0][:email]).to eq('contato@nascerdosol.com.br')
      expect(parsed_body[0][:description]).to eq('Descrição da Pousada Nascer do Sol')
      expect(parsed_body[0][:pets]).to eq(false)
      expect(parsed_body[0][:use_policy]).to eq('Não é permitido fumar nas dependências da pousada')
      expect(DateTime.parse(parsed_body[0][:checkin_hour])).to eq(guesthouse[0].checkin_hour)
      expect(DateTime.parse(parsed_body[0][:checkout_hour])).to eq(guesthouse[0].checkout_hour)
      expect(parsed_body[0][:active]).to eq(true)
      expect(parsed_body[0][:address][:street]).to eq('Avenida 0, 0000')
      expect(parsed_body[0][:address][:neighborhood]).to eq('Bairro 0')
      expect(parsed_body[0][:address][:city]).to eq('Itapetininga')
      expect(parsed_body[0][:address][:state]).to eq('SP')
      expect(parsed_body[0][:address][:postal_code]).to eq('01001-000')
      expect(parsed_body[0][:payment_methods][0][:method]).to eq('credit_card')
      expect(parsed_body[0][:payment_methods][1][:method]).to eq('debit_card')
      expect(parsed_body[0][:payment_methods][2][:method]).to eq('pix')
      expect(parsed_body[0].keys).to_not include(:created_at)
      expect(parsed_body[0].keys).to_not include(:updated_at)

      expect(parsed_body[1][:corporate_name]).to eq nil
      expect(parsed_body[1][:brand_name]).to eq('Pousada Praiana')
      expect(parsed_body[1][:registration_code]).to eq nil
      expect(parsed_body[1][:phone_number]).to eq('21598308183')
      expect(parsed_body[1][:email]).to eq('contato@praiana.com.br')
      expect(parsed_body[1][:description]).to eq('Descrição da Pousada Praiana')
      expect(parsed_body[1][:pets]).to eq(false)
      expect(parsed_body[1][:use_policy]).to eq('Não é permitido fumar nas dependências da pousada')
      expect(DateTime.parse(parsed_body[1][:checkin_hour])).to eq(guesthouse[1].checkin_hour)
      expect(DateTime.parse(parsed_body[1][:checkout_hour])).to eq(guesthouse[1].checkout_hour)
      expect(parsed_body[1][:active]).to eq(true)
      expect(parsed_body[1][:address][:street]).to eq('Avenida 2, 2000')
      expect(parsed_body[1][:address][:neighborhood]).to eq('Bairro 2')
      expect(parsed_body[1][:address][:city]).to eq('Camboriú')
      expect(parsed_body[1][:address][:state]).to eq('SC')
      expect(parsed_body[1][:address][:postal_code]).to eq('21001-000')
      expect(parsed_body[1][:payment_methods][0][:method]).to eq('credit_card')
      expect(parsed_body[1][:payment_methods][1][:method]).to eq('debit_card')
      expect(parsed_body[1][:payment_methods][2][:method]).to eq('pix')
      expect(parsed_body[1].keys).to_not include(:created_at)
      expect(parsed_body[1].keys).to_not include(:updated_at)
    end

    it 'returns a empty list of guesthouses' do
      # Arrange
      # Act
      get '/api/v1/guesthouses'

      # Assert
      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')

      parsed_body = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_body).to be_empty
    end
  end

  context 'GET /api/v1/guesthouses/?search=ana' do
    it 'returns a list of active guesthouses filtered by name' do
      # Arrange
      cities = %w[Itapetininga Sorocaba Camboriú]
      states = %w[SP SP SC]
      guesthouses_names = %w[Nascer\ do\ Sol Sorocabana Praiana]
      user_names = %w[Joao Marlene Cesar]
      guesthouse =  {
        0 => '', 1 => ''
      }
      user = {
        0 => '', 1 => ''
      }
      guesthouse_owner = {
        0 => '', 1 => ''
      }

      PaymentMethod.create!(method: 'credit_card')
      PaymentMethod.create!(method: 'debit_card')
      PaymentMethod.create!(method: 'pix')

      guesthouses_names.each_with_index do |name, index|
        user[index] = User.create!(name: user_names[index], email: "#{user_names[index].downcase}@email.com",
                                   password: 'password', role: 1)
        guesthouse_owner[index] = user[index].build_guesthouse_owner
        guesthouse[index] = guesthouse_owner[index].build_guesthouse(corporate_name: "#{name} LTDA.",
                                                                     brand_name: "Pousada #{name}",
                                                                     registration_code: "#{index}47032102000152",
                                                                     phone_number: "#{index}1598308183",
                                                                     email: "contato@#{name.downcase.gsub(" ", "")}.com.br",
                                                                     description: "Descrição da Pousada #{name}",
                                                                     pets: index.odd? ? true : false,
                                                                     use_policy: 'Não é permitido fumar nas dependências da pousada',
                                                                     checkin_hour: '14:00', checkout_hour: '12:00',
                                                                     active: index.even? ? true : false)

        guesthouse[index].build_address(street: index.odd? ? "Rua #{index},  #{index}000" : "Avenida #{index}, #{index}000",
                                        neighborhood: index.even? ? "Bairro #{index}" : "Centro #{index}",
                                        city: cities[index], state: states[index], postal_code: "#{index}1001-000")

        guesthouse[index].payment_methods = PaymentMethod.all
        guesthouse[index].save!
      end

      # Act
      get '/api/v1/guesthouses/?search=ana'

      # Assert
      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')

      parsed_body = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_body.size).to eq(1)
      expect(parsed_body[0][:brand_name]).to eq('Pousada Praiana')
      expect(parsed_body[0][:phone_number]).to eq('21598308183')
      expect(parsed_body[0][:email]).to eq('contato@praiana.com.br')
      expect(parsed_body[0][:description]).to eq('Descrição da Pousada Praiana')
      expect(parsed_body[0][:pets]).to eq(false)
      expect(parsed_body[0][:use_policy]).to eq('Não é permitido fumar nas dependências da pousada')
      expect(DateTime.parse(parsed_body[0][:checkin_hour])).to eq(guesthouse[0].checkin_hour)
      expect(DateTime.parse(parsed_body[0][:checkout_hour])).to eq(guesthouse[0].checkout_hour)
      expect(parsed_body[0][:active]).to eq(true)
      expect(parsed_body[0][:address][:street]).to eq('Avenida 2, 2000')
      expect(parsed_body[0][:address][:neighborhood]).to eq('Bairro 2')
      expect(parsed_body[0][:address][:city]).to eq('Camboriú')
      expect(parsed_body[0][:address][:state]).to eq('SC')
      expect(parsed_body[0][:address][:postal_code]).to eq('21001-000')
      expect(parsed_body[0][:payment_methods][0][:method]).to eq('credit_card')
      expect(parsed_body[0][:payment_methods][1][:method]).to eq('debit_card')
      expect(parsed_body[0][:payment_methods][2][:method]).to eq('pix')
      expect(parsed_body[0].keys).to_not include(:created_at)
      expect(parsed_body[0].keys).to_not include(:updated_at)
      expect(parsed_body[0].keys).to_not include(:corporate_name)
      expect(parsed_body[0].keys).to_not include(:registration_code)
    end
  end

  context 'GET /api/v1/guesthouses/1' do
    it 'returns a guesthouse' do
      # Arrange
      cities = %w[Itapetininga Sorocaba Camboriú]
      states = %w[SP SP SC]
      guesthouses_names = %w[Nascer\ do\ Sol Sorocabana Praiana]
      user_names = %w[Joao Marlene Cesar]
      guesthouse =  {
        0 => '', 1 => ''
      }
      user = {
        0 => '', 1 => ''
      }
      guesthouse_owner = {
        0 => '', 1 => ''
      }

      PaymentMethod.create!(method: 'credit_card')
      PaymentMethod.create!(method: 'debit_card')
      PaymentMethod.create!(method: 'pix')

      guesthouses_names.each_with_index do |name, index|
        user[index] = User.create!(name: user_names[index], email: "#{user_names[index].downcase}@email.com",
                                   password: 'password', role: 1)
        guesthouse_owner[index] = user[index].build_guesthouse_owner
        guesthouse[index] = guesthouse_owner[index].build_guesthouse(corporate_name: "#{name} LTDA.",
                                                                     brand_name: "Pousada #{name}",
                                                                     registration_code: "#{index}47032102000152",
                                                                     phone_number: "#{index}1598308183",
                                                                     email: "contato@#{name.downcase.gsub(" ", "")}.com.br",
                                                                     description: "Descrição da Pousada #{name}",
                                                                     pets: index.odd? ? true : false,
                                                                     use_policy: 'Não é permitido fumar nas dependências da pousada',
                                                                     checkin_hour: '14:00', checkout_hour: '12:00',
                                                                     active: index.even? ? true : false)

        guesthouse[index].build_address(street: index.odd? ? "Rua #{index},  #{index}000" : "Avenida #{index}, #{index}000",
                                        neighborhood: index.even? ? "Bairro #{index}" : "Centro #{index}",
                                        city: cities[index], state: states[index], postal_code: "#{index}1001-000")

        guesthouse[index].payment_methods = PaymentMethod.all
        guesthouse[index].save!
      end

      # Act
      get "/api/v1/guesthouses/#{guesthouse[0].id}"

      # Assert
      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')

      parsed_body = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_body[:brand_name]).to eq('Pousada Nascer do Sol')
      expect(parsed_body[:phone_number]).to eq('01598308183')
      expect(parsed_body[:email]).to eq('contato@nascerdosol.com.br')
      expect(parsed_body[:description]).to eq('Descrição da Pousada Nascer do Sol')
      expect(parsed_body[:pets]).to eq(false)
      expect(parsed_body[:use_policy]).to eq('Não é permitido fumar nas dependências da pousada')
      expect(DateTime.parse(parsed_body[:checkin_hour])).to eq(guesthouse[0].checkin_hour)
      expect(DateTime.parse(parsed_body[:checkout_hour])).to eq(guesthouse[0].checkout_hour)
      expect(parsed_body[:active]).to eq(true)
      expect(parsed_body[:address][:street]).to eq('Avenida 0, 0000')
      expect(parsed_body[:address][:neighborhood]).to eq('Bairro 0')
      expect(parsed_body[:address][:city]).to eq('Itapetininga')
      expect(parsed_body[:address][:state]).to eq('SP')
      expect(parsed_body[:address][:postal_code]).to eq('01001-000')
      expect(parsed_body[:payment_methods][0][:method]).to eq('credit_card')
      expect(parsed_body[:payment_methods][1][:method]).to eq('debit_card')
      expect(parsed_body[:payment_methods][2][:method]).to eq('pix')
      expect(parsed_body.keys).to_not include(:created_at)
      expect(parsed_body.keys).to_not include(:updated_at)
      expect(parsed_body.keys).to_not include(:corporate_name)
      expect(parsed_body.keys).to_not include(:registration_code)
    end
  end
end