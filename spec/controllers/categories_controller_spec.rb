require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  after do
    DatabaseCleaner.clean
  end

  describe 'GET #index' do
    subject { get :index }

    context 'expect to be successfully, render index' do
      let(:admin) { create(:user, :admin) }
      let(:category) { create(:category) }

      before do
        sign_in admin
        category
        subject
      end

      it { expect(response).to have_http_status '200' }
      it { is_expected.to render_template :index }
      it { expect(assigns(:categories).size).to eq(1) }
    end

    context 'expect to be fail, as a guest' do
      let(:category) { create(:category) }

      before do
        category
        subject
      end

      it { expect(response).to have_http_status '302' }
      it { expect(assigns(:categories)).to be_nil }
      it { is_expected.not_to render_template :index }
      it "redirects to the sign-in page" do
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe 'GET #show' do
    subject { get :show, params: params }

    context 'expect to be successfully, render show' do
      let(:params) { { id: category.id } }
      let(:admin) { create(:user, :admin) }
      let(:category) { create(:category) }

      before do
        sign_in admin
        subject
      end

      it { expect(response).to be_successful }
      it { expect(response).to have_http_status '200' }
      it { is_expected.to render_template :show }
    end

    context 'expect to be fail, as a guest' do
      let(:params) { { id: category.id } }
      let(:category) { create(:category) }

      before do
        category
        subject
      end

      it { expect(response).to have_http_status '302' }
      it { expect(assigns(:category)).to be_nil }
      it { is_expected.not_to render_template :index }
      it "redirects to the sign-in page" do
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    context 'expect to be fail, the category to show not exist' do
      let(:admin) { create(:user, :admin) }
      let(:category) { create(:category, :with_specific_id) }
      let(:params) { { id: 2 } }

      before do
        sign_in admin
      end

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe 'POST #create' do
    let(:admin) { create(:user, :admin) }

    let(:category_params) do
      { name: 'Home' }
    end

    let(:invalid_category_params) do
      { name: '' }
    end

    context 'as an authenticated user' do
      before do
        sign_in admin
      end

      context 'with valid attributes' do
        it "adds a category" do
          expect {
            post :create, params: { category: category_params }
          }.to change(Category, :count).by(1)
        end
      end

      context "with invalid attributes" do
        it "adds a category" do
          expect {
            post :create, params: {  category: invalid_category_params }
          }.to_not change(Category, :count)
        end
      end
    end

    context "as a guest" do
      it "returns a 302 response" do
        post :create, params: { category: category_params }
        expect(response).to have_http_status '302'
      end

      it "redirects to the sign-in page" do
        post :create, params: { category: category_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    context "as normal user" do
      let(:user) { create(:user) }
      before do
        sign_in user
      end

      it "adds a category" do
        expect {
          post :create, params: {  category: category_params }
        }.to_not change(Category, :count)
      end
    end
  end

  describe 'GET #new' do
    subject { get :new, params: { } }

    context 'expect be successfully' do
      let(:admin) { create(:user, :admin) }

      before do
        sign_in admin
        subject
      end

      it { expect(assigns(:category)).to_not be_nil }
      it { expect(assigns(:category)).to be_a_new(Category) }
      it { expect(response).to be_successful }
      it { expect(response).to have_http_status '200' }
      it { is_expected.to render_template :new }
    end
  end

  describe 'PATCH #update' do
    subject { patch :update, params: params }

    context 'update category, singned in ad admin' do
      let(:category) { create(:category) }
      let(:admin) { create(:user, :admin) }

      let(:params) do
        { id: category.id,
          category: { name: 'Home' } }

      end

      before do
        sign_in admin
      end

      it { expect{ subject }.to change{ category.reload.name }.from('Technology').to('Home') }
      it { expect(response).to be_successful }
      it { expect(response).to have_http_status '200' }
    end

    context 'update expect to be fail, invalid params' do
      let(:category) { create(:category) }
      let(:admin) { create(:user, :admin) }
      let(:params) do
        { id: category.id,
          category: { name: '' } }
      end

      before do
        sign_in admin
      end

      it { expect{ subject }.to_not change{ category.reload.name } }
    end

    context 'try update without be admin' do
      let(:user) { create(:user) }
      let(:category) { create(:category) }
      let(:params) do
        { id: category.id,
          category: { name: 'Home' } }
      end

      before do
        sign_in user
      end

      it { expect{ subject }.to_not change{ category.reload.name } }
    end

    context 'expect to be fail, the category to update not exist' do
      let(:admin) { create(:user, :admin) }
      let(:category) { create(:category, :with_specific_id) }
      let(:params) do
        { id: 3,
          category: { name: 'Home' } }
      end

      before do
        sign_in admin
      end

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: params }
    let(:admin) { create(:user, :admin) }

    context 'delete, with as admin user' do
      let(:category) { create(:category) }
      let(:params) { { id: category.id } }

      before do
        category
        sign_in admin
      end

      it { expect{ subject }.to change(Category, :count).by(-1) }
    end

    context 'try to delete without sign in, as a guest' do
      let(:category) { create(:category) }
      let(:params) { { id: category.id } }

      before do
        category
      end

      it { expect{ subject }.to_not change(Category, :count) }

      it "redirects to the sign-in page" do
        subject
        expect(response).to have_http_status "302"
        expect(response).to redirect_to "/users/sign_in"
      end
    end


    context 'try to delete, as normal user' do
      let(:category) { create(:category) }
      let(:user) { create(:user) }
      let(:params) { { id: category.id } }

      before do
        category
        sign_in user
      end

      it { expect{ subject }.to_not change(Category, :count) }
    end
  end
end
