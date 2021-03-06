# frozen_string_literal: true

# module user
module Users
  # omniauth callbacks controller used to get the callback of the API
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token

    def facebook
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
      else
        user = User.find_by(email: @user.email)

        user.provider = @user.provider
        user.uid = @user.uid
        user.save

        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
      end
    end

    def google_oauth2
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
      else
        user = User.find_by(email: @user.email)

        user.provider = @user.provider
        user.uid = @user.uid
        user.save

        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
      end
    end
  end
end
