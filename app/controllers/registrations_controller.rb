class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)
    if resource.role == 'guesthouse_owner'
      save_guesthouse_owner_transaction
    else
      if resource.save
        handle_successful_save
      else
        handle_failed_save
      end
    end

    if resource.persisted?
      handle_successful_save
    else
      clean_up_passwords resource
      set_minimum_password_length
    end
  end

  protected

  def after_sign_up_path_for(resource)
    if resource.role == 'guesthouse_owner'
      new_guesthouse_path
    else
      super
    end
  end

  def after_sign_in_path_for(resource)
    if resource.role == 'guesthouse_owner'
      new_guesthouse_path
    else
      super
    end
  end

  # def after_inactive_sign_up_path_for(resource)
  #   root_path
  # end

  private

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
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
      expire_data_after_sign_in!
      respond_with resource, location: after_inactive_sign_up_path_for(resource)
    end
  end
end
