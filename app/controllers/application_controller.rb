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

  def valid_product_owner
    return true if belongs_to_current_user(@product.user_id)

    message = 'You cannot do this action, you are not the owner of this product.'

    respond_to do |format|
      format.html do
        redirect_to products_url,
                    alert: message
      end
    end
    false
  end

  def valid_account_owner
    return true if belongs_to_current_user(@user.id)

    message = 'You cannot do this action, this account does not belong to you.'

    respond_to do |format|
      format.html do
        redirect_to users_url,
                    alert: message
      end
    end
    false
  end

  def valid_admin
    return true if current_user.admin_role?

    message = 'You cannot do this action, you are not ADMIN.'

    respond_to do |format|
      format.html do
        redirect_to users_url,
                    alert: message
      end
    end
    false
  end

  private

  def belongs_to_current_user(id)
    id == current_user.id || current_user.admin_role?
  end
end
