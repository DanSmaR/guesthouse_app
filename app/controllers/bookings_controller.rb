class BookingsController < ApplicationController
  def new
    @room = Room.find(params[:room_id])
    @booking = @room.bookings.new
    @guesthouse = @room.guesthouse
  end
end
