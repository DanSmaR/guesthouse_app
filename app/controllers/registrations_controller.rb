class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)
    if resource.role == 'guesthouse_owner'
      save_guesthouse_owner_transaction
    elsif resource.role == 'guest'
      if resource.save
        handle_successful_save
        # redirect_to additional_info_path(id: resource.id)
      else
        clean_up_passwords resource
        set_minimum_password_length
        render :new
      end
    else
      if resource.save
        handle_successful_save
      else
        handle_failed_save
      end
    end
  end

  def additional_info
    @user = User.find(params[:id])
    @guest = @user.build_guest
  end

  def save_additional_info
    @user = User.find(params[:id])
    @guest = @user.build_guest(guest_params)
    unless @guest.save
      puts @guest.errors.full_messages
      raise ActiveRecord::Rollback
    end

    if @user.persisted? && @guest.persisted?
      sign_up(resource_name, resource)
      if session[:booking]
        id = session[:booking]['room_id'].to_s
        redirect_to room_final_confirmation_path(id)
      else
        redirect_to root_path
      end
    else
      render :additional_info
    end
  end

  private
  def guest_params
    params.require(:guest).permit(:identification_register_number, :name, :surname)
  end

  def save_guesthouse_owner_transaction
    resource.transaction do
      if resource.save
        @guesthouse_owner = GuesthouseOwner.new(user: resource)
        unless @guesthouse_owner.save
          clean_up_passwords resource
          set_minimum_password_length
          flash[:alert] = 'Erro ao criar conta.'
          redirect_to new_user_registration_path
          raise ActiveRecord::Rollback
        else
          handle_successful_save
        end
      else
        handle_failed_save
      end
    end
  end

  def handle_failed_save
    clean_up_passwords resource
    set_minimum_password_length
    respond_with resource
  end

  def handle_successful_save
    if resource.active_for_authentication?
      set_flash_message! :notice, :signed_up
      sign_up(resource_name, resource)
      # TODO : double render error
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
      expire_data_after_sign_in!
      respond_with resource, location: after_inactive_sign_up_path_for(resource)
    end
  end

  protected
  def after_sign_up_path_for(resource)
    if resource.role == 'guesthouse_owner'
      new_guesthouse_path
    elsif resource.role == 'guest'
      new_additional_info_path(resource)
    else
      super
    end
  end
end
