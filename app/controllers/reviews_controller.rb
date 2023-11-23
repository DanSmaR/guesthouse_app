class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :get_review, only: [:respond, :update]

  def index
    @guesthouse = Guesthouse.find(params[:guesthouse_id])
    @reviews = @guesthouse.reviews
  end

  def guesthouse_owner
    @guesthouse = current_user.guesthouse_owner.guesthouse
    @reviews = @guesthouse.reviews
    render :index
  end

  def respond
  #
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

  def update
    if @review.update(respond_params)
      flash[:notice] = 'Resposta adicionada com sucesso!'
      redirect_to guesthouse_reviews_path(@review.guesthouse)
    else
      flash.now[:alert] = 'Não foi possível adicionar a resposta'
      render :respond
    end
  end

  private

  def get_review
    @review = current_user.guesthouse_owner.guesthouse.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def respond_params
    params.require(:review).permit(:response)
  end
end
