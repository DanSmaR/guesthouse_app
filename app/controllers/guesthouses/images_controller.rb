class Guesthouses::ImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_guesthouse

  def destroy
    image = @guesthouse.images.find params[:id]
    image.purge
    flash[:notice] = "Imagem removida com sucesso"
    redirect_to edit_guesthouse_path(@guesthouse)
  end

  private

  def set_guesthouse
    @guesthouse = Guesthouse.find(params[:guesthouse_id])
    unless current_user&.guesthouse_owner&.guesthouse == @guesthouse
      flash[:alert] = "Não possui autorização para acessar esse recurso"
      redirect_back fallback_location: root_path
    end
  end
end