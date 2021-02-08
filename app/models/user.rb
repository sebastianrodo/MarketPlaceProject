# frozen_string_literal: true

# Class user model
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2]

  has_many :products, dependent: :delete_all

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :cellphone, uniqueness: true, format: { without: /\A[a-zA-Z]+\z/,
                                                    message: 'only allows numbers' }

  def self.from_omniauth(auth)
    name_split = auth.info.name.split(' ')
    auth.info.first_name = name_split[0] if auth.info.first_name.blank?
    auth.info.last_name = name_split[1] if auth.info.last_name.blank?
  end

  def create_user_with_omniauth(auth)
    user = User.where(email: auth.info.email).first
    user ||= User.create!(provider: auth.provider, uid: auth.uid,
                          first_name: auth.info.first_name, last_name: auth.info.last_name,
                          email: auth.info.email, password: Devise.friendly_token[0, 20])
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.google_oauth2'] && session['devise.google_oauth2_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
      end

      if data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
      end
    end
  end
end
