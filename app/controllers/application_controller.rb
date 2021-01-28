class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:email, :password, :first_name, :last_name, :cellphone, :address)}

    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:email, :password, :current_password, :first_name, :last_name, :cellphone, :address)}
  end

  def valid_product_owner!
    return true if @product.user_id === current_user.id

    respond_to do |format|
      format.html { redirect_to products_url,
                    alert: 'You cannot do this action, you are not the owner of this product.' }
      format.json { head :no_content }
    end
    false
  end

  def valid_account_owner!
    return true if @user.id === current_user.id

    respond_to do |format|
      format.html { redirect_to products_url,
                    alert: 'You cannot do this action, this account does not belong to you' }
      format.json { head :no_content }
    end
    false
  end
end
