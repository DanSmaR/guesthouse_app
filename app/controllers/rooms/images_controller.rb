class Rooms::ImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_guesthouse_owner!
  before_action :set_room

  def destroy
    image = @room.images.find params[:id]
    image.purge
    flash[:notice] = "Imagem removida com sucesso"
    redirect_to edit_guesthouse_room_path(@room.guesthouse, @room)
  end

  private

  def set_room
    @room = current_user&.guesthouse_owner&.guesthouse&.rooms&.find(params[:room_id])
    if @room.nil?
      flash[:alert] = "Não possui autorização para acessar esse recurso"
      redirect_back fallback_location: root_path
    end
  end
end