class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  allow_browser versions: :modern

  helper_method :cart

  def cart
    session[:cart] ||= {}
  end

  protected

  def configure_permitted_parameters
    # For sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name phone])

    # For updating the account later
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
  end
end
