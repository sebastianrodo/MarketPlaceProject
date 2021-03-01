class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:email, :password, :first_name, :last_name, :cellphone, :address)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:email, :password, :current_password, :first_name, :last_name, :cellphone, :address)
    end
  end

  def valid_product_owner!
    @product.user_id === current_user.id
  end

  def valid_account_owner!
    @user.id === current_user.id
  end
end
