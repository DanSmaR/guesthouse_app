# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# populate payment_methods table
%w[credit_card debit_card pix].each do |method|
  PaymentMethod.find_or_create_by!(method: method)
end

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
guesthouse.payment_methods = PaymentMethod.all
guesthouse.save!
guesthouse.rooms.create!([{ name: 'Quarto Primavera', description: 'Quarto com vista para a serra', size: 30,
                            max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                            air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                            available: true },
                          { name: 'Quarto Verão', description: 'Quarto com vista para o mar', size: 30,
                            max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                            air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                            available: false }])
guesthouse.rooms.first&.room_rates&.create!([{ start_date: '2021-01-01', end_date: '2021-01-31', daily_rate: 100 },
                                             { start_date: '2021-02-01', end_date: '2021-02-28', daily_rate: 200 }])

user2 = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password', role: 1)
guesthouse_owner2 = user2.build_guesthouse_owner
guesthouse2 = guesthouse_owner2.build_guesthouse(corporate_name: 'Casa do Saber LTDA.',
                                                 brand_name: 'Casa do Saber',
                                                 registration_code: '47032102000152',
                                                 phone_number: '15983081833',
                                                 email: 'contato@casadosaber.com.br',
                                                 description: 'Pousada com muito conhecimeto',
                                                 pets: true,
                                                 use_policy: 'Não é permitido fumar nas dependências da pousada',
                                                 checkin_hour: '14:00', checkout_hour: '12:00', active: true)
guesthouse2.build_address(street: 'Rua da Sucata, 1000', neighborhood: 'Vila Minas Gerais' ,
                          city: 'Itapevi', state: 'SP', postal_code: '01001-000')

guesthouse2.payment_methods = PaymentMethod.all
guesthouse2.save!