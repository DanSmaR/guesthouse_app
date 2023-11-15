class BookingsController < ApplicationController
  def new
    @room = Room.find(params[:room_id])
    @booking = @room.bookings.new
    @guesthouse = @room.guesthouse
  end

  def verify_availability
    @room = Room.find(params[:room_id])
    @guesthouse = @room.guesthouse
    @booking = @room.bookings.new(booking_params)

    if @booking.valid? && @booking.check_availability
      session[:booking] = booking_params.to_h
      @total_price = @booking.total_price
      flash[:notice] = 'Quarto disponível!'
      render :confirm
    else
      render :new
    end
  end

  private
  def booking_params
    params.require(:booking).permit(:check_in_date, :check_out_date, :number_of_guests)
  end
end
