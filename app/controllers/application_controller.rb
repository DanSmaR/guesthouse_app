class ApplicationController < ActionController::Base
  # call the configure_permitted_parameters method before any action in our application
  # if the controller that the action is coming from is a devise_controller
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # permit the name attribute for the sign_up action
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
