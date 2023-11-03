class RoomRatesController < ApplicationController
  before_action :set_guesthouse_and_room, only: %i[new create]
  before_action :authorize_room_rate_creation, only: %i[new create]
  # TODO - add link to edit room rate in room show page
  def new
    if current_user&.guesthouse_owner&.guesthouse&.rooms&.exists?(@room.id)
      @room_rate = @room.room_rates.new
    else
      redirect_to guesthouse_rooms_path(@guesthouse),
                  alert: 'Você não tem permissão para cadastrar diárias'
    end
  end

  def create
    @room_rate = @room.room_rates.new(room_rate_params)
    if @room_rate.save
      redirect_to guesthouse_room_path(@room.guesthouse, @room)
    else
      flash.now[:alert] = 'Não foi possível cadastrar a diária'
      render :new
    end
  end

  private

  def set_guesthouse_and_room
    @guesthouse = Guesthouse.find(params[:guesthouse_id])
    @room = @guesthouse.rooms.find(params[:room_id])
  end

  def room_rate_params
    params.require(:room_rate).permit(:daily_rate, :start_date, :end_date)
  end

  def authorize_room_rate_creation
    unless current_user&.guesthouse_owner&.guesthouse&.rooms&.exists?(@room.id)
      redirect_to guesthouse_rooms_path(@guesthouse),
                  alert: 'Você não tem permissão para cadastrar diárias'
    end
  end
end
