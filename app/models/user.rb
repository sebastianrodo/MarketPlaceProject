# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  address                :string
#  admin_role             :boolean          default(FALSE)
#  cellphone              :string(15)
#  email                  :string           not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  last_name              :string           not null
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string
#  user_role              :boolean          default(TRUE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Class user model
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2]

  has_many :products, dependent: :delete_all

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :cellphone, uniqueness: true,
                        allow_blank: true,
                        allow_nil: true,
                        format: { without: /\A[a-zA-Z]+\z/,
                                  message: 'only allows numbers' }

  def self.from_omniauth(auth)
    name_split = auth.info.name.split(' ')
    auth.info.first_name = name_split[0] if auth.info.first_name.blank?
    auth.info.last_name = name_split[1] if auth.info.last_name.blank?

    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
    end
  end
end
