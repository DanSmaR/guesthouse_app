require 'rails_helper'

describe 'User delete image from guesthouse' do
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

    (1..3).map do |id|
      guesthouse.images.attach(
        io: File.open("app/assets/images/guesthouse/pousada_#{id}.jpg"),
        filename: "pousada_#{id}.jpg",
        content_type: "image/jpeg"
      )
    end

    # Act
    login_as(user)
    visit edit_guesthouse_path(guesthouse)

    # Assert
    expect(page).to have_field('Imagens')
    expect(page).to have_button 'Remover', count: 3
    expect(find("img[src*='pousada_][src$='.jpg'']")).to eq 3
    (1..3).each { |id| expect(page).to have_css("img[src*='pousada_#{id}.jpg']") }
  end
end