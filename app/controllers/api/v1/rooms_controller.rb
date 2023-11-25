class Api::V1::RoomsController < Api::V1::ApiController
  def index
    guesthouse = Guesthouse.find(params[:guesthouse_id])
    rooms = guesthouse.rooms.where(available: true)

    render json: rooms.as_json(except: [:created_at, :updated_at, :available]), status: :ok
  end

  def availability
    room = Room.find(params[:id])
    booking = room.bookings.new(booking_params)

    unless booking&.required_fields
      return render json: { message: 'Preencha todos os campos!', errors: booking.errors.full_messages },
                    status: :bad_request
    end

    unless booking.check_availability
      return render json: { message: 'Quarto Indisponível!',
                            errors: booking.errors.full_messages,
                            available: false },
                    status: :conflict
    end

    render json: { message: 'Quarto disponível!',
                   total_price: booking.get_total_price,
                   available: true },
           status: :ok
  end

  private

  def booking_params
    params.permit(:check_in_date, :check_out_date, :number_of_guests)
  end
end