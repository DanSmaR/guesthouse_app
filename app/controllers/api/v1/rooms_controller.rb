class Api::V1::RoomsController < Api::V1::ApiController
  def index
    guesthouse = Guesthouse.find(params[:guesthouse_id])
    rooms = guesthouse.rooms.where(available: true)

    render json: rooms.as_json(except: [:created_at, :updated_at, :available]), status: :ok
  end

  def availability
    room = Room.find(params[:id])
    booking = room.bookings.new(booking_params)
    if booking&.required_fields && booking.check_availability
      render json: { message: 'Quarto disponível!',
                     total_price: booking.get_total_price,
                     available: true },
             status: :ok
    else
      render json: { message: 'Quarto não disponível neste período. Tente novamente' }, status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.permit(:check_in_date, :check_out_date, :number_of_guests)
  end
end