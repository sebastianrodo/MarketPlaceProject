# frozen_string_literal: true

# ApplicationController
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
    return true if (@product.user_id == current_user.id) || current_user.admin_role?

    respond_to do |format|
      format.html do
        redirect_to products_url,
                    alert: 'You cannot do this action, you are not the owner of this product.'
      end
      format.json { head :no_content }
    end
    false
  end

  def valid_account_owner!
    return true if (@user.id == current_user.id) || current_user.admin_role?

    flash.now[:alert] = 'You cannot do this action, this account does not belong to you.'
    respond_to do |format|
      format.html do
        redirect_to users_url,
                    alert: 'You cannot do this action, this account does not belong to you.'
      end
      format.json { head :no_content }
    end
    false
  end
end
