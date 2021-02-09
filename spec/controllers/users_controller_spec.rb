require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  after do
    DatabaseCleaner.clean
  end

  describe 'GET #index' do
    subject { get :index }

    context 'expect to be successfully, with an authenticated user' do
      let(:user) { create(:user) }

      before do
        sign_in user
        FactoryBot.create_list(:user, 3)
        subject
      end

      it { expect(response).to have_http_status '200' }
      it { is_expected.to render_template :index }
      it { expect(assigns(:users).size).to eq(4) }
    end

    context 'expect to be successfully, with just the user signed in record created' do
      let(:user) { create(:user) }

      before do
        sign_in user
        subject
      end

      it { expect(response).to be_successful }
      it { expect(response).to have_http_status '200' }
      it { is_expected.to render_template :index }
      it { expect(assigns(:users).size).to eq(1) }
    end

    context 'expect to be fail, as a guest' do
      before do
        FactoryBot.create_list(:user, 3)
        subject
      end

      it { expect(response).to have_http_status '302' }
      it { expect(assigns(:users)).to be_nil }
      it { is_expected.not_to render_template :index }
      it "redirects to the sign-in page" do
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe 'GET #show' do
    subject { get :show, params: params }

    context 'expect to be successfully, with an authenticated user' do
      let(:user) { create(:user) }
      let(:params) { { id: user.id } }

      before do
        sign_in user
        subject
      end
      it { expect(response).to be_successful }
      it { expect(response).to have_http_status '200' }
      it { is_expected.to render_template :show }
    end

    context 'expect to be fail, as a guest' do
      let(:user) { create(:user) }
      let(:params) { { id: user.id } }

      before do
        subject
      end

      it { expect(response).to have_http_status '302' }
      it { is_expected.not_to render_template :show }
      it "redirects to the sign-in page" do
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    context 'expect to be fail, the user to show not exist' do
      let(:user) { create(:user, :with_specific_id) }
      let(:params) { { id: 2 } }

      before do
        sign_in user
      end

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe 'GET #new' do
    subject { get :new, params: { } }

    context 'expect be successfully' do
      let(:user) { create(:user) }

      before do
        sign_in user
        subject
      end

      it { expect(assigns(:user)).to_not be_nil }
      it { expect(assigns(:user)).to be_a_new(User) }
      it { expect(response).to be_successful }
      it { expect(response).to have_http_status '200' }
      it { is_expected.to render_template :new }
    end
  end

  describe 'PATCH #update' do
    subject { patch :update, params: params }

    context 'update current user, singned in' do
      let(:user) { create(:user) }
      let(:params) do
        { id: user.id,
          user: { first_name: 'Julio',
                  current_password: '12345678' } }
      end

      before do
        sign_in user
      end

      it { expect{ subject }.to change{ user.reload.first_name }.from('Fake_name').to('Julio') }
      it { expect(response).to be_successful }
      it { expect(response).to have_http_status '200' }
    end

    context 'update expect to be fail, invalid params' do
      let(:user) { create(:user) }
      let(:params) do
        { id: user.id,
          user: { first_name: '',
                  current_password: '12345678' } }
      end

      before do
        sign_in user
      end

      it { expect{ subject }.to_not change{ user.reload.first_name } }
    end

    context 'update another user that not is the current' do
      let(:user) { create(:user) }
      let(:another_user) { create(:user, :another) }
      let(:params) do
        { id: user.id,
          user: { first_name: 'Carlos',
                  current_password: '12345678' } }
      end

      before do
        another_user
        sign_in user
      end

      it { expect{ subject }.to_not change{ another_user.reload.first_name } }
    end

    context 'expect to be fail, the user to update not exist' do
      let(:user) { create(:user, :with_specific_id) }
      let(:params) do
        { id: 3,
          user: { first_name: 'Julio',
                  current_password: '12345678' } }
      end

      before do
        sign_in user
      end

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'update another user, as admin' do
      let(:user) { create(:user) }
      let(:admin) { create(:user, :admin) }
      let(:params) do
        { id: user.id,
          user: { first_name: 'Juan',
                  current_password: '12345678' } }
      end

      before do
        sign_in admin
      end

      it { expect{ subject }.to change{ user.reload.first_name }.from('Fake_name').to('Juan') }
      it { expect(response).to be_successful }
      it { expect(response).to have_http_status '200' }
    end

    context 'try to update without sign in, as a guest' do
      let(:user) { create(:user) }
      let(:params) do
        { id: user.id,
          user: { first_name: 'Carlos',
                  current_password: '12345678' } }
      end

      it { expect{ subject }.to_not change{ user.reload.first_name } }

      it "redirects to the sign-in page" do
        subject
        expect(response).to have_http_status "302"
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: params }

    context 'delete, with an authenticated user' do
      let(:user) { create(:user) }
      let(:params) { { id: user.id } }

      before do
        sign_in user
      end

      it { expect{ subject }.to change(User, :count).by(-1) }
    end

    context 'try to delete another user that not belongs to them' do
      let(:user) { create(:user) }
      let(:user2) { create(:user, :with_specific_id) }
      let(:params) { { id: user2.id } }

      before do
        sign_in user
        user2
      end

      it { expect{ subject }.to_not change(User, :count) }
    end

    context 'as admin, delete another user' do
      let(:user) { create(:user) }
      let(:admin) { create(:user, :admin) }
      let(:params) { { id: user.id }}

      before do
        sign_in admin
        user
      end

      it{ expect{ subject }.to change(User, :count).by(-1) }
    end

    context 'try to delete without sign in, as a guest' do
      let(:user) { create(:user) }
      let(:params) { { id: user.id } }

      before do
        user
      end

      it { expect{ subject }.to_not change(User, :count) }

      it "redirects to the sign-in page" do
        subject
        expect(response).to have_http_status "302"
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
