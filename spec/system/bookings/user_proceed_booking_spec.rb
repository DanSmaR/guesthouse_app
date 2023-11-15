require 'rails_helper'

describe 'User proceed booking' do
  context 'when not logged in' do
    it 'is redirected to login page' do
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
      guesthouse.rooms.create!([{ name: 'Quarto Primavera', description: 'Quarto com vista para a serra', size: 30,
                                  max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                                  air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                  available: true }])
      guesthouse.rooms.first&.bookings&.create!(check_in_date: 2.day.from_now, check_out_date: 4.days.from_now,
                                                number_of_guests: 2)

      visit root_path
      click_on 'Pousada Nascer do Sol'
      click_on 'Reservar', match: :first
      fill_in 'Data de Check-in', with: 1.day.from_now
      fill_in 'Data de Check-out', with: 2.days.from_now
      fill_in 'Quantidade de Hóspedes', with: 2
      click_on 'Verificar Disponibilidade'

      # Act
      click_on 'Prosseguir com a Reserva'

      # Assert
      expect(current_path).to eq(new_user_session_path)
    end

    context 'when not registered' do
      it 'registers and proceeds booking' do
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
        guesthouse.rooms.create!([{ name: 'Quarto Primavera', description: 'Quarto com vista para a serra', size: 30,
                                    max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                                    air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                    available: true }])
        guesthouse.rooms.first&.bookings&.create!(check_in_date: 2.day.from_now, check_out_date: 4.days.from_now,
                                                  number_of_guests: 2)

        visit root_path
        click_on 'Pousada Nascer do Sol'
        click_on 'Reservar', match: :first
        fill_in 'Data de Check-in', with: 1.day.from_now
        fill_in 'Data de Check-out', with: 2.days.from_now
        fill_in 'Quantidade de Hóspedes', with: 2
        click_on 'Verificar Disponibilidade'

        # Act
        click_on 'Prosseguir com a Reserva'
        click_on 'Registrar-se'
        fill_in 'Nome', with: 'Maria'
        fill_in 'E-mail', with: 'maria@email.com'
        select 'Hóspede', from: 'Tipo de Usuário'
        fill_in 'Senha', with: 'password'
        fill_in 'Confirme sua senha', with: 'password'
        click_on 'Criar conta'

        # Assert
        expect(current_path).to eq(new_guest_path)
      end
    end
  end
end