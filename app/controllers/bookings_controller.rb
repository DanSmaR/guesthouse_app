class BookingsController < ApplicationController
  def new
    @room = Room.find(params[:room_id])
    @booking = @room.bookings.new
    @guesthouse = @room.guesthouse
  end

  def availability
    @room = Room.find(params[:room_id])
    @guesthouse = @room.guesthouse
    @booking = @room.bookings.new(booking_params)

    if @booking.valid? && @booking.check_availability
      session[:booking] = booking_params.to_h
      flash[:notice] = 'Quarto disponível!'
      redirect_to confirm_room_bookings_path(@room)
    else
      render :new
    end
  end

  def confirm
    @room = Room.find(params[:room_id])
    @guesthouse = @room.guesthouse
    @booking = @room.bookings.new(session[:booking])
    @total_price = @booking.total_price
  end

  private
  def booking_params
    params.require(:booking).permit(:check_in_date, :check_out_date, :number_of_guests)
  end
end
