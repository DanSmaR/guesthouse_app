# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :set_guesthouse, only: %i[index new create show]

  def index
    @rooms = @guesthouse.rooms
  end
  def new
    @room = Room.new
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
    @room = Room.find(params[:id])
  end

  private

  def set_guesthouse
    @guesthouse = Guesthouse.find(params[:guesthouse_id])
  end

  def room_params
    params.require(:room).permit(:name, :description, :size,
                                 :max_people, :daily_rate,
                                 :bathroom, :balcony,
                                 :air_conditioning, :tv,
                                 :wardrobe, :safe,
                                 :accessible, :available)
  end
end
