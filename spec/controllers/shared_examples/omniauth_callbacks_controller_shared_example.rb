require 'rails_helper'

shared_examples_for 'OmniauthSignInControllerSpec' do
  context 'no previously created account' do
    before(:each) do
      user_stub
    end

    it 'should create user, redirect to homepage, and create session' do
      expect{ subject }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
    end
  end

  context 'get #google, expect user sign in' do
    before(:each) do
      create(:user, :custom_email)
      user_stub

      subject
      @user = User.where(email: 'sarodriguez5244@misena.edu.co').first
    end

    it { expect(@user).not_to be_nil }

    it { expect be_user_signed_in }
  end

  context 'account created previously, without omniauth authentication' do
    before(:each) do
      create(:user, :custom_email)

      user_stub
    end

    it { expect{ subject }.not_to change(User, :count) }

    it 'expect add the provider credential of google authentication to the user' do
      user = User.where(email: 'sarodriguez5244@misena.edu.co').first

      expect{ subject }.to change{ user.reload.uid }.from(nil).to(uid)
    end

    it 'expect add the uid credential of google authentication to the user' do
      user = User.where(email: 'sarodriguez5244@misena.edu.co').first

      expect{ subject }.to change{ user.reload.provider }.from(nil).to(provider)
    end
  end
end
