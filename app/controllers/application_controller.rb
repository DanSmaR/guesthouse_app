class ApplicationController < ActionController::Base
  # call the configure_permitted_parameters method before any action in our application
  # if the controller that the action is coming from is a devise_controller
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_guesthouse_owner

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

  protected

  def configure_permitted_parameters
    # permit the name attribute for the sign_up action
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
  end

  def authorize_owner
    unless current_user
      redirect_to new_user_session_path, alert: 'Você precisa estar autenticado para acessar essa página' and return
    end
    unless @guesthouse.guesthouse_owner.user == current_user
      redirect_to @guesthouse, alert: 'Você não tem permissão para editar outras pousadas'
    end
  end
end
