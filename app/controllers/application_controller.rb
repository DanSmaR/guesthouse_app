class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
  # call the configure_permitted_parameters method before any action in our application
  # if the controller that the action is coming from is a devise_controller
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_guesthouse_owner

  private

  def not_found_error
    flash[:alert] = "Não possui autorização para acessar esse recurso"
    redirect_back fallback_location: root_path, status: 303
  end

  def redirect_guesthouse_owner
    # TODO: when user is already registered and is trying to login again, it should receive a message
    unless request.path == guesthouses_path
      if current_user&.role == 'guesthouse_owner' && current_user&.guesthouse_owner&.guesthouse.nil?
        unless request.path == new_guesthouse_path || request.path == destroy_user_session_path
          # check if the user is coming from a sign in action
          if request.referer == new_user_session_url
            flash[:notice] = 'Login efetuado com sucesso. Por favor, cadastre uma pousada para continuar'
          else
            flash[:alert] = 'Você precisa cadastrar uma pousada para continuar'
          end
          redirect_to new_guesthouse_path
        end
      end
    end
  end

  protected

  def configure_permitted_parameters
    # permit the name attribute for the sign_up action
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
  end

  protected

  def after_sign_in_path_for(resource)
    if resource.role == 'guesthouse_owner'
      root_path
    elsif resource.guest? && Guest.find_by(user: resource).nil?
      new_additional_info_path(resource)
    else
      super
    end
  end

  def validate_image_type(img_params)
    is_valid = true
    img_params.each do |image|
      next if image.blank?
      unless image.content_type.in?(%w[image/jpeg image/png])
        is_valid = false
        break
      end
    end
    is_valid
  end

  def add_to_previous_images(instance_model, img_params)
    instance_model.images.attach(img_params)
    instance_model.images.blobs
  end
end
