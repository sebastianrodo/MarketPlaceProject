# frozen_string_literal: true

# class notifier mailer
class NotifierMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier_mailer.email.subject
  #
  def email(user, product)
    @user = user
    @product = product

    mail(to: @user.email, subject: 'A new product has been published')
  end
end
