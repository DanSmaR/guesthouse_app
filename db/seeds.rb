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

# Arrange
cities = %w[Itapetininga Sorocaba São\ Paulo Rio\ de\ Janeiro Belo\ Horizonte Sorocaba]
states = %w[SP SP SP RJ MG SP]
guesthouses_names =
  %w[Nascer\ do\ Sol Lua\ Cheia Estrela\ Cadente Lago\ Verde Raio\ de\ Sol Vista\ Linda]
user_names = %w[Joao Maria Jose Pedro Ana Paulo]
guesthouse =  {
  0 => '', 1 => '', 2 => '', 3 => '', 4 => '', 5 => ''
}
user = {
  0 => '', 1 => '', 2 => '', 3 => '', 4 => '', 5 => ''
}
guesthouse_owner = {
  0 => '', 1 => '', 2 => '', 3 => '', 4 => '', 5 => ''
}

user_guest = User.create!(name: 'Marcia', email: 'marcia@email.com', password: 'password', role: 0)
guest = user_guest.create_guest!(name: 'Marcia', surname: 'Silva', identification_register_number: '12345678910')

guesthouses_names.each_with_index do |name, index|
  user[index] = User.create!(name: user_names[index], email: "#{user_names[index].downcase}@email.com",
                             password: 'password', password_confirmation: 'password', role: 1)
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
                                                               active: index == 2 ? false : true)

  guesthouse[index].build_address(street: index.odd? ? "Rua #{index},  #{index}000" : "Avenida #{index}, #{index}000",
                                  neighborhood: index.even? ? "Bairro #{index}" : "Centro #{index}",
                                  city: cities[index], state: states[index], postal_code: "#{index}1001-000")

  guesthouse[index].payment_methods = PaymentMethod.all
  guesthouse[index].save!

  guesthouse[index].rooms.create!([{ name: "Quarto Primavera #{index}",
                                     description: 'Quarto com vista para a serra',
                                     size: 30, max_people: 2, daily_rate: 100,
                                     bathroom: true, balcony: true,
                                     air_conditioning: index.even? ? true : false,
                                     tv: index.odd? ? true : false, wardrobe: true,
                                     safe: true, accessible: index.even? ? true : false,
                                     available: true },
                                   { name: "Quarto Verão #{index}",
                                     description: 'Quarto com vista para o mar',
                                     size: 30, max_people: 2, daily_rate: 100,
                                     bathroom: true, balcony: true,
                                     air_conditioning: index == 1 ? false : true,
                                     tv: index == 1 ? false : true, wardrobe: true,
                                     safe: true, accessible: index == 0 ? false : true,
                                     available: index.odd? ? true : false }])
  guesthouse[index].rooms.first&.room_rates&.create!([{ start_date: 2.days.from_now,
                                                        end_date: 20.days.from_now,
                                                        daily_rate: (index + 2) * 100 },
                                                      { start_date: 2.months.from_now,
                                                        end_date: 3.months.from_now,
                                                        daily_rate: (index + 1) * 100 }])
  guesthouse[index].rooms.first&.bookings&.create!([{check_in_date: 0.days.from_now, check_out_date: 2.days.from_now,
                                                     number_of_guests: 2, guest: guest, total_price: 200, status: 0,
                                                     check_in_hour: '14:00', check_out_hour: '12:00',
                                                     reservation_code: "#{index}A123AC1"},
                                                    {check_in_date: 4.days.from_now, check_out_date: 5.days.from_now,
                                                     number_of_guests: 2, guest: guest, total_price: 100, status: 0,
                                                     check_in_hour: '14:00', check_out_hour: '12:00',
                                                     reservation_code: "#{index}B123AC1"}])
end

# Arrange
cities2 = %w[Ouro\ Preto Camboriu]
states2 = %w[MG SC]
guesthouses_names2 =
  %w[Serrana Praiana]
user_names2 = %w[Cesar Simone]
guesthouse2 =  {
  0 => '', 1 => ''
}
user2 = {
  0 => '', 1 => ''
}
guesthouse_owner2 = {
  0 => '', 1 => ''
}

guesthouses_names2.each_with_index do |name, index|
  user2[index] = User.create!(name: user_names2[index], email: "#{user_names2[index].downcase}@email.com",
                              password: 'password', password_confirmation: 'password', role: 1)
  guesthouse_owner2[index] = user2[index].build_guesthouse_owner
  guesthouse2[index] = guesthouse_owner2[index].build_guesthouse(corporate_name: "#{name} LTDA.",
                                                                 brand_name: "Pousada #{name}",
                                                                 registration_code: "#{index}47032102000152",
                                                                 phone_number: "#{index}1598308183",
                                                                 email: "contato@#{name.downcase.gsub(" ", "")}.com.br",
                                                                 description: "Descrição da Pousada #{name}",
                                                                 pets: index.odd? ? true : false,
                                                                 use_policy: 'Não é permitido fumar nas dependências da pousada',
                                                                 checkin_hour: '14:00', checkout_hour: '12:00',
                                                                 active: true)

  guesthouse2[index].build_address(street: index.odd? ? "Rua #{index},  #{index}000" : "Avenida #{index}, #{index}000",
                                   neighborhood: index.even? ? "Bairro #{index}" : "Centro #{index}",
                                   city: cities2[index], state: states2[index], postal_code: "#{index}1001-000")

  guesthouse2[index].payment_methods = PaymentMethod.all
  guesthouse2[index].save!

  guesthouse2[index].rooms.create!([{ name: "Quarto Aquarela #{index}",
                                      description: 'Quarto com vista para a serra',
                                      size: 30, max_people: 2, daily_rate: 100,
                                      bathroom: true, balcony: true,
                                      air_conditioning: index.even? ? true : false,
                                      tv: index.even? ? true : false, wardrobe: true,
                                      safe: true, accessible: index.even? ? true : false,
                                      available: true },
                                    { name: "Quarto Oceano #{index}",
                                      description: 'Quarto com vista para o mar',
                                      size: 30, max_people: 2, daily_rate: 100,
                                      bathroom: true, balcony: true,
                                      air_conditioning: index == 0 ? false : true,
                                      tv: index == 1 ? false : true, wardrobe: true,
                                      safe: true, accessible: index == 0 ? false : true,
                                      available: index.odd? ? true : false }])
  guesthouse2[index].rooms.first&.room_rates&.create!([{ start_date: '2021-01-01',
                                                         end_date: '2021-01-31',
                                                         daily_rate: (index + 2) * 100 },
                                                       { start_date: '2021-02-01',
                                                         end_date: '2021-02-28',
                                                         daily_rate: (index + 1) * 100 }])
  guesthouse2[index].rooms.first&.bookings&.create!([{check_in_date: 0.days.from_now, check_out_date: 2.days.from_now,
                                                     number_of_guests: 2, guest: guest, total_price: 200, status: 0,
                                                     check_in_hour: '14:00', check_out_hour: '12:00',
                                                     reservation_code: "#{index}C123AC1"},
                                                    {check_in_date: 4.days.from_now, check_out_date: 5.days.from_now,
                                                     number_of_guests: 2, guest: guest, total_price: 100, status: 0,
                                                     check_in_hour: '14:00', check_out_hour: '12:00',
                                                     reservation_code: "#{index}D123AC1"}])
end
