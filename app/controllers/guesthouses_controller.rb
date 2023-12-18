class GuesthousesController < ApplicationController
  before_action :set_guesthouse, only: [:show, :edit, :update]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  def new
    @guesthouse_owner = current_user.guesthouse_owner || current_user.create_guesthouse_owner
    if @guesthouse_owner.guesthouse.present?
      redirect_to @guesthouse_owner.guesthouse, alert: 'Você já possui uma Pousada.'
    else
      @guesthouse = @guesthouse_owner.build_guesthouse
      @guesthouse.build_address
    end
  end

  def create
    @guesthouse_owner = current_user.guesthouse_owner
    @guesthouse = @guesthouse_owner.build_guesthouse(guesthouse_params)
    @guesthouse.payment_method_ids = params[:guesthouse][:payment_method_ids]
    if @guesthouse.save
      flash[:notice] = 'Pousada cadastrada com sucesso'
      redirect_to @guesthouse
    else
      flash.now[:alert] = 'Pousada não cadastrada. Preencha todos os campos.'
      render :new
    end
  end

  def show
    if current_user&.guesthouse_owner&.guesthouse == @guesthouse
      @rooms = @guesthouse.rooms
    else
      @rooms = @guesthouse.rooms.filter(&:available)
    end
    @reviews = @guesthouse.reviews.last(3)
  end

  def edit
  #
  end

  def update
    @guesthouse.payment_method_ids = params[:guesthouse][:payment_method_ids]
    if params[:guesthouse][:images].blank? && @guesthouse.images.attached?
      params[:guesthouse][:images] = @guesthouse.images
    else
      params[:guesthouse][:images] = @guesthouse.images.attach(params[:guesthouse][:images])
    end
    if @guesthouse.update(guesthouse_params)
      flash[:notice] = 'Pousada atualizada com sucesso'
      redirect_to @guesthouse
    else
      flash.now[:alert] = 'Pousada não atualizada. Preencha todos os campos.'
      render :edit
    end
  end

  private

  def guesthouse_params
    params.require(:guesthouse).permit(:corporate_name, :brand_name, :description,
                                       :registration_code, :phone_number,
                                       :email, :description,
                                       :use_policy, :checkin_hour,
                                       :checkout_hour, :pets,
                                       :active, payment_method_ids: [],
                                        address_attributes: [:id, :street, :neighborhood,
                                                             :city, :state, :postal_code], images: [])
  end

  def set_guesthouse
    @guesthouse = Guesthouse.find(params[:id])
  end
end
