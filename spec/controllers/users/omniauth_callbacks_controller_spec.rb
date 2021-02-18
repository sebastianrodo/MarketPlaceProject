require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, :type => :controller do
  describe 'Facebook' do
    subject { get :facebook }
    let(:user_stub) { stub_env_for_omniauth_facebook }
    let(:provider) { 'facebook' }
    let(:uid) { '1234' }

    it_behaves_like 'OmniauthSignInControllerSpec'
  end

  describe 'Google' do
    subject { get :google_oauth2}
    let(:user_stub) { stub_env_for_omniauth_google }
    let(:provider) { 'google' }
    let(:uid) { '1234' }

    it_behaves_like 'OmniauthSignInControllerSpec'
  end

end
