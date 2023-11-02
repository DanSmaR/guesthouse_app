class GuesthousesController < ApplicationController
  before_action :set_guesthouse, only: [:show, :edit, :update]
  before_action :authorize_owner, only: [:edit, :update]
  def new
    if current_user
      @guesthouse_owner = current_user.guesthouse_owner || current_user.create_guesthouse_owner
      if @guesthouse_owner.guesthouse.present?
        redirect_to @guesthouse_owner.guesthouse, alert: 'Você já possui uma Pousada.'
      else
        @guesthouse = @guesthouse_owner.build_guesthouse
        @guesthouse.build_address
      end
    else
      redirect_to new_user_session_path, alert: 'Você precisa estar logado para cadastrar uma pousada'
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
  #
  end

  def edit
  #
  end

  def update
    @guesthouse.payment_method_ids = params[:guesthouse][:payment_method_ids]
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
    puts '-' * 50
    puts params
    puts '-' * 50
    params.require(:guesthouse).permit(:corporate_name, :brand_name, :description,
                                       :registration_code, :phone_number,
                                       :email, :description,
                                       :use_policy, :checkin_hour,
                                       :checkout_hour, :pets,
                                       :active, payment_method_ids: [],
                                        address_attributes: [:id, :street, :neighborhood,
                                                             :city, :state, :postal_code])
  end

  def create_payment_methods(resource = @guesthouse)
    params[:payment_methods]&.each do |payment_method|
      pm = PaymentMethod.find_by(method: payment_method)
      unless resource.payment_methods.exists?(pm)
        resource.payment_methods << pm
      end
    end
  end

  def set_guesthouse
    @guesthouse = Guesthouse.find(params[:id])
  end
  def authorize_owner
    unless @guesthouse.guesthouse_owner.user == current_user
      redirect_to @guesthouse, alert: 'Você não tem autorização para editar essa pousada'
    end
  end
end
