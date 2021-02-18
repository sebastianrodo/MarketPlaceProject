# frozen_string_literal: true

module Users
  # omniauth callbacks controller used to get the callback of the API
  class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
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

    def failure

      binding.pry

      redirect_to root_path
    end
  end
end
