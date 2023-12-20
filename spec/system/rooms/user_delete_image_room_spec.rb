require 'rails_helper'

describe 'User delete image from room' do
  it 'successfully' do
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
                                available: true },
                              { name: 'Quarto Verão', description: 'Quarto com vista para o mar', size: 30,
                                max_people: 2, daily_rate: 100, bathroom: true, balcony: true,
                                air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true,
                                available: false }])

    (1..3).map do |id|
      guesthouse.rooms.first&.images&.attach(
        io: File.open("app/assets/images/rooms/room_#{id}.jpg"),
        filename: "room_#{id}.jpg",
        content_type: "image/jpeg"
      )
    end

    # Act
    login_as(user)
    visit edit_guesthouse_room_path(guesthouse, guesthouse.rooms.first)

    # Assert
    expect(all("img[src*='room_'][src$='.jpg']").count).to eq 3
    (1..3).each { |id| expect(page).to have_css("img[src$='room_#{id}.jpg']") }
    expect(page).to have_button 'Remover', count: 3

    click_button 'Remover', match: :first

    expect(page).to have_content 'Imagem removida com sucesso'
    expect(all("img[src*='room_'][src$='.jpg']").count).to eq 2
    expect(page).to_not have_css("img[src$='room_1.jpg']")
    expect(page).to have_button 'Remover', count: 2
  end
end