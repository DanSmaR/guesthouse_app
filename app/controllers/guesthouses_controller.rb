class GuesthousesController < ApplicationController
  before_action :set_guesthouse, only: [:show, :edit, :update]
  def new
    @guest_owner = current_user.guesthouse_owner
    @guesthouse = @guest_owner.build_guesthouse
    @guesthouse.build_address
  end

  def create
    @guest_owner = current_user.guesthouse_owner
    @guesthouse = @guest_owner.build_guesthouse(guesthouse_params)
    create_payment_methods
    if @guesthouse.save
      flash[:notice] = 'Pousada cadastrada com sucesso'
      redirect_to @guesthouse
    else
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
                                       :active, :payment_methods,
                                        address_attributes: [:street, :neighborhood,
                                                             :city, :state, :postal_code])
  end

  def create_payment_methods(resource = @guesthouse)
    params[:payment_methods].each do |payment_method|
      unless resource.payment_methods.exists?(payment_method)
        resource.payment_methods << PaymentMethod.find_or_create_by(method: payment_method)
      end
    end
  end

  def set_guesthouse
    @guesthouse = Guesthouse.find(params[:id])
  end
end
