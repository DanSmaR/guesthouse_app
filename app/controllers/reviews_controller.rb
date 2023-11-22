class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    @guesthouse = Guesthouse.find(params[:guesthouse_id])
    @reviews = @guesthouse.reviews
  end

  def create
    @booking = current_user.guest.bookings.find(params[:booking_id])
    @review = @booking&.build_review(review_params)
    @review.guest = current_user.guest

    if @review.save
      flash[:notice] = 'Avaliação adicionada com sucesso!'
      redirect_to booking_path(@booking)
    else
      flash[:alert] = 'Não foi possível adicionar a avaliação'
      redirect_to booking_path(@booking)
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
