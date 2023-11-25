require 'rails_helper'

describe 'Rooms API', type: :request do
  context 'GET /api/v1/guesthouses/1/rooms' do
    it 'returns a list of available rooms' do
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

        guesthouse[index].rooms.create!([{ name: "Quarto Aquarela #{index}",
                                           description: 'Quarto com vista para a serra',
                                           size: 30, max_people: 2, daily_rate: 100,
                                           bathroom: true, balcony: true,
                                           air_conditioning: index.even? ? true : false,
                                           tv: index.even? ? true : false, wardrobe: true,
                                           safe: true, accessible: index.even? ? true : false,
                                           available: true },
                                         { name: "Quarto Oceano #{index}",
                                           description: 'Quarto com vista para o mar',
                                           size: 40, max_people: 3, daily_rate: 200,
                                           bathroom: true, balcony: true,
                                           air_conditioning: index == 0 ? false : true,
                                           tv: index == 1 ? false : true, wardrobe: true,
                                           safe: true, accessible: index == 0 ? false : true,
                                           available: false },
                                          { name: "Quarto Céu #{index}",
                                            description: 'Quarto com vista para a montanha',
                                            size: 50, max_people: 4, daily_rate: 300,
                                            bathroom: true, balcony: true,
                                            air_conditioning: index.even? ? true : false,
                                            tv: index.even? ? true : false, wardrobe: true,
                                            safe: true, accessible: index.even? ? true : false,
                                            available: true }])
      end

      # Act
      get '/api/v1/guesthouses/1/rooms'

      # Assert
      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')

      parsed_body = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_body.size).to eq(2)
      expect(parsed_body[0][:name]).to eq('Quarto Aquarela 0')
      expect(parsed_body[0][:description]).to eq('Quarto com vista para a serra')
      expect(parsed_body[0][:size]).to eq(30)
      expect(parsed_body[0][:max_people]).to eq(2)
      expect(parsed_body[0][:daily_rate]).to eq("100.0")
      expect(parsed_body[0][:bathroom]).to eq(true)
      expect(parsed_body[0][:balcony]).to eq(true)
      expect(parsed_body[0][:air_conditioning]).to eq(true)
      expect(parsed_body[0][:tv]).to eq(true)
      expect(parsed_body[0][:wardrobe]).to eq(true)
      expect(parsed_body[0][:safe]).to eq(true)
      expect(parsed_body[0][:accessible]).to eq(true)
      expect(parsed_body[0][:guesthouse_id]).to eq(1)
      expect(parsed_body[0].keys).to_not include(:created_at)
      expect(parsed_body[0].keys).to_not include(:updated_at)
      expect(parsed_body[0].keys).to_not include(:available)

      expect(parsed_body[1][:name]).to eq('Quarto Céu 0')
      expect(parsed_body[1][:description]).to eq('Quarto com vista para a montanha')
      expect(parsed_body[1][:size]).to eq(50)
      expect(parsed_body[1][:max_people]).to eq(4)
      expect(parsed_body[1][:daily_rate]).to eq("300.0")
      expect(parsed_body[1][:bathroom]).to eq(true)
      expect(parsed_body[1][:balcony]).to eq(true)
      expect(parsed_body[1][:air_conditioning]).to eq(true)
      expect(parsed_body[1][:tv]).to eq(true)
      expect(parsed_body[1][:wardrobe]).to eq(true)
      expect(parsed_body[1][:safe]).to eq(true)
      expect(parsed_body[1][:accessible]).to eq(true)
      expect(parsed_body[1][:guesthouse_id]).to eq(1)
      expect(parsed_body[1].keys).to_not include(:created_at)
      expect(parsed_body[1].keys).to_not include(:updated_at)
      expect(parsed_body[0].keys).to_not include(:available)
    end

    it 'returns a empty list of rooms' do
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
      get '/api/v1/guesthouses/1/rooms'

      # Assert
      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')

      parsed_body = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_body).to be_empty
    end
  end

  context 'GET /api/v1/guesthouses/1/rooms/1/?check_in_date=' do
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
      expect(parsed_body[:average_rating]).to eq(guesthouse[0].average_rating)
      expect(parsed_body.keys).to_not include(:created_at)
      expect(parsed_body.keys).to_not include(:updated_at)
      expect(parsed_body.keys).to_not include(:corporate_name)
      expect(parsed_body.keys).to_not include(:registration_code)
    end

    it 'fails if it is not found' do
      # Arrange
      # Act
      get '/api/v1/guesthouses/0'

      # Assert
      expect(response).to have_http_status(:not_found)
      expect(response.content_type).to include('application/json')

      parsed_body = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_body[:message]).to eq('Not found')
    end

    it 'raises an internal error' do
      # Arrange
      allow(Guesthouse).to receive(:all).and_raise(ActiveRecord::ActiveRecordError)

      # Act
      get '/api/v1/guesthouses'

      # Assert
      expect(response).to have_http_status(:internal_server_error)
      expect(response.content_type).to include('application/json')
    end
  end
end