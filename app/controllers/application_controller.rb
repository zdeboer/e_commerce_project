class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper_method :cart

  def cart
    session[:cart] ||= {}
  end
end
