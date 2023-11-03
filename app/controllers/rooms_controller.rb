class RoomsController < ApplicationController
  before_action :set_guesthouse, only: %i[index new create show edit update]
  before_action :set_room, only: %i[show edit update]
  before_action :authenticate_user!, only: %i[new create edit update]

  def index
    if current_user&.guesthouse_owner&.guesthouse == @guesthouse
      @rooms = @guesthouse.rooms
    else
      @rooms = @guesthouse.rooms.filter(&:available)
    end
  end
  def new
    if current_user&.guesthouse_owner&.guesthouse == @guesthouse
      @room = Room.new
    else
      redirect_to guesthouse_rooms_path(@guesthouse), alert: 'Você não tem permissão para cadastrar quartos'
    end
  end

  def create
    @room = Room.new(room_params)
    @room.guesthouse = @guesthouse
    if @room.save
      redirect_to guesthouse_room_path(@room.guesthouse, @room)
    else
      flash.now[:alert] = 'Não foi possível cadastrar o quarto'
      render :new
    end
  end

  def show
    @room_rates = @room.room_rates
  #
  end

  def edit
  #
  end

  def update
    if @room.update(room_params)
      flash[:notice] = 'Quarto atualizado com sucesso'
      redirect_to guesthouse_room_path(@room.guesthouse, @room)
    else
      flash.now[:alert] = 'Não foi possível atualizar o quarto'
      render :edit
    end
  end

  private

  def set_guesthouse
    @guesthouse = Guesthouse.find(params[:guesthouse_id])
  end

  def set_room
    @room = Room.find(params[:id])
  end


  def room_params
    params.require(:room).permit(:name, :description, :size,
                                 :max_people, :daily_rate,
                                 :bathroom, :balcony,
                                 :air_conditioning, :tv,
                                 :wardrobe, :safe,
                                 :accessible, :available)
  end

  # TODO - Refactor the content of this method
end
