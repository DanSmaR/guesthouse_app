class ApplicationController < ActionController::Base
  # call the configure_permitted_parameters method before any action in our application
  # if the controller that the action is coming from is a devise_controller
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_guesthouse_owner
  before_action :set_cities

  private

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

  def set_cities
    @cities = Guesthouse.all.map(&:address).map(&:city).uniq
  end

  protected

  def configure_permitted_parameters
    # permit the name attribute for the sign_up action
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
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
      root_path
    else
      super
    end
  end
end
