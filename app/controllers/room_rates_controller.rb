class RoomRatesController < ApplicationController
  before_action :set_guesthouse_and_room, only: %i[new create edit update]
  before_action :authenticate_user!, only: %i[new create edit update]
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
      flash[:notice] = 'Diária cadastrada com sucesso'
      redirect_to guesthouse_room_path(@room.guesthouse, @room)
    else
      flash.now[:alert] = 'Não foi possível cadastrar a diária'
      render :new
    end
  end

  def edit
    @room_rate = @room.room_rates.find(params[:id])
  end

  def update
    @room_rate = @room.room_rates.find(params[:id])
    if @room_rate.update(room_rate_params)
      flash[:notice] = 'Diária atualizada com sucesso'
      redirect_to guesthouse_room_path(@room.guesthouse, @room)
    else
      flash.now[:alert] = 'Não foi possível atualizar a diária'
      render :edit
    end
  end

  private

  def set_guesthouse_and_room
    @room = Room.find(params[:room_id])
    @guesthouse = @room.guesthouse
  end

  def room_rate_params
    params.require(:room_rate).permit(:daily_rate, :start_date, :end_date)
  end
end
