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
      it 'registers and proceeds to additional guest info' do
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
        expect(current_path).to eq(new_additional_info_path(User.guest.last))
      end

      it 'registers and proceeds to final confirmation' do
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
        fill_in 'CPF', with: '12345678910'
        fill_in 'Nome', with: 'Maria'
        fill_in 'Sobrenome', with: 'Silva'
        click_on 'Salvar'

        # Assert
        expect(current_path).to eq(room_final_confirmation_path(Room.last))
        expect(page).to have_content('Quarto: Quarto Primavera')
        expect(page).to have_field('Data de Check-in', with: 1.day.from_now.strftime('%d/%m/%Y'))
        expect(page).to have_content('Hora do Check-In: 14:00')
        expect(page).to have_field('Data de Check-out', with: 2.days.from_now.strftime('%d/%m/%Y'))
        expect(page).to have_content('Hora do Check-Out: 12:00')
        expect(page).to have_field('Quantidade de Hóspedes', with: 2)
        expect(page).to have_content('Preço Total: R$ 100,00')
        expect(page).to have_content('Métodos de Pagamento:')
        expect(page).to have_content('Cartão de crédito')
        expect(page).to have_content('Cartão de débito')
        expect(page).to have_content('Pix')
      end
    end

    context 'when registered as guest and logged in' do
      it 'concludes booking' do
        # Arrange
        user = User.create!(name: 'João', email: 'joao@email.com', password: 'password', role: 1)
        user2 = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password', role: 0)
        guest = user2.create_guest!(name: 'Maria', surname: 'Silva', identification_register_number: '12345678910')
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

        login_as user2, scope: :user
        visit root_path
        click_on 'Pousada Nascer do Sol'
        click_on 'Reservar', match: :first
        fill_in 'Data de Check-in', with: 1.day.from_now
        fill_in 'Data de Check-out', with: 2.days.from_now
        fill_in 'Quantidade de Hóspedes', with: 2
        click_on 'Verificar Disponibilidade'
        click_on 'Prosseguir com a Reserva'

        # Act
        click_on 'Concluir Reserva'

        # Assert
        expect(current_path).to eq(booking_path(Booking.last))
        expect(page).to have_content('Reserva realizada com sucesso!')
        expect(page).to have_content('Detalhes da Reserva ' + Booking.last.reservation_code)
        expect(page).to have_content('Situação: Pendente')
        expect(page).to have_content('Quarto: Quarto Primavera')
        expect(page).to have_content("Data de Check-in: #{1.day.from_now.strftime('%d/%m/%Y')}")
        expect(page).to have_content('Hora de Check-in: 14:00')
        expect(page).to have_content("Data de Check-out: #{2.days.from_now.strftime('%d/%m/%Y')}")
        expect(page).to have_content('Hora de Check-out: 12:00')
        expect(page).to have_content('Quantidade de Hóspedes: 2')
        expect(page).to have_content('Preço Total: R$ 100,00')
      end
    end
  end
end

# TODO: Add tests to user logged in, but not registered as guest, trying to proceed booking
# TODO: url access to booking pages when not logged in