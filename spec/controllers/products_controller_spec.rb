require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  after do
    DatabaseCleaner.clean
  end

  describe 'GET #index' do
    subject { get :index }

    context 'expect to be successfully, render index' do
      before do
        FactoryBot.create_list(:product, 3, :published)
        subject
      end

      it { expect(response).to have_http_status '200' }
      it { is_expected.to render_template :index }
      it { expect(assigns(:products).size).to eq(3) }
    end

    context 'expect to be successfully, but with any with state published' do
      before do
        FactoryBot.create_list(:product, 3)
        subject
      end

      it { expect(response).to have_http_status '200' }
      it { is_expected.to render_template :index }
      it { expect(assigns(:products).size).to eq(0) }
    end
  end

  describe 'GET #show' do
    subject { get :show, params: params }

    context 'expect to be successfully' do
      let(:user) { create(:user) }
      let(:product) { create(:product) }
      let(:params) { { id: product.id } }

      before do
        subject
      end

      it { expect(response).to have_http_status '200' }
      it { is_expected.to render_template :show }
    end

    context 'expect to be fail, the product to show not exist' do
      let(:product) { create(:product, :with_specific_id) }
      let(:params) { { id: 2 } }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:category) { create(:category) }

    let(:product_params) do
      { name: 'PC MASTER RACE',
        description: '4gb RAM, 2TB SOLID DISK',
        quantity: 9,
        price: 5000000,
        state: 0,
        user_id: user.id,
        category_id: category.id }
    end

    context 'as an authenticated user' do
      let(:invalid_product_params) do
        { name: 'PC MASTER RACE' }
      end

      before do
        sign_in user
      end

      context 'with valid attributes' do
        it "adds a product" do
          expect {
            post :create, params: { product: product_params }
          }.to change(Product, :count).by(1)
        end
      end

      context "with invalid attributes" do
        it "adds a product" do
          expect {
            post :create, params: {  product: invalid_product_params }
          }.to_not change(Product, :count)
        end
      end
    end

    context "as a guest" do
      it "returns a 302 response" do
        post :create, params: { product: product_params }
        expect(response).to have_http_status '302'
      end

      it "redirects to the sign-in page" do
        post :create, params: { product: product_params }
        expect(response).to redirect_to "/users/sign_in"
      end
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

      it { expect(assigns(:product)).to_not be_nil }
      it { expect(assigns(:product)).to be_a_new(Product) }
      it { expect(response).to be_successful }
      it { expect(response).to have_http_status '200' }
      it { is_expected.to render_template :new }
    end
  end

  describe 'PATCH #update' do
    subject { patch :update, params: params }

    context 'update product, signed in' do
      let(:product) { create(:product) }
      let(:params) do
        { id: product.id,
          product: { name: 'Laptop Gamer' } }
      end

      before do
        sign_in product.user
      end

      it { expect{ subject }.to change{ product.reload.name }.from('PC MASTER RACE').to('Laptop Gamer') }
      it { expect(response).to be_successful }
      it { expect(response).to have_http_status '200' }
    end

    context 'update a product that not belongs to you' do
      let(:another_user) { create(:user, :another) }
      let(:product) { create(:product) }
      let(:params) do
        { id: product.id,
          product: { name: 'Laptop Gamer' } }
      end

      before do
        sign_in another_user
      end

      it { expect{ subject }.to_not change{ product.reload.name } }
    end

    context 'expect fail, invalid attributes' do
      let(:product) { create(:product) }
      let(:params) do
        { id: product.id,
          product: { name: '' } }
      end

      before do
        product
        sign_in product.user
      end

      it { expect{ subject }.to_not change{ product.reload.name } }
    end

    context 'expect to be fail, the product to update not exist' do
      let(:user) { create(:user) }
      let(:product) { create(:product, :with_specific_id) }
      let(:params) do
        { id: 2,
          product: { name: 'Laptop Gamer' } }
      end

      before do
        sign_in product.user
      end

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'update a product, as admin' do
      let(:admin) { create(:user, :admin) }
      let(:product) { create(:product) }
      let(:params) do
        { id: product.id,
          product: { name: 'Laptop Gamer' } }
      end

      before do
        sign_in admin
      end

      it { expect{ subject }.to change{ product.reload.name }.from('PC MASTER RACE').to('Laptop Gamer') }
      it { expect(response).to be_successful }
      it { expect(response).to have_http_status '200' }
    end

    context 'try to update without sign in, as a guest' do
      let(:product) { create(:product) }
      let(:params) do
        { id: product.id,
          product: { name: 'Laptop Gamer' } }
      end

      it { expect{ subject }.to_not change{ product.reload.name } }

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
      let(:product) { create(:product) }
      let(:params) { { id: product.id } }

      before do
        sign_in product.user
      end

      it { expect{ subject }.to change(Product, :count).by(-1) }
    end

    context 'try to delete a product that not belongs to you' do
      let(:another_user) { create(:user, :another) }
      let(:product) { create(:product) }
      let(:params) { { id: product.id } }

      before do
        sign_in another_user
        product
      end

       it { expect{ subject }.to_not change(Product, :count) }
    end

    context 'as admin, delete a user not belongs to you' do
      let(:admin) { create(:user, :admin) }
      let(:product) { create(:product) }
      let(:params) { { id: product.id } }

      before do
        sign_in admin
        product
      end

      it{ expect{ subject }.to change(Product, :count).by(-1) }
    end

    context 'try to delete without sign in, as a guest' do
      let(:product) { create(:product) }
      let(:params) { { id: product.id } }

      before do
        product
      end

      it { expect{ subject }.to_not change(Product, :count) }

      it "redirects to the sign-in page" do
        subject
        expect(response).to have_http_status "302"
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe '#archive' do
    subject { controller.archive }

    let(:product) { create(:product) }

    before do
      controller.instance_variable_set(:@product, product)
    end

    it { expect{ subject }.to change{ assigns(:product).state }.from('unpublished').to('archived') }
  end

  describe '#publish' do
    subject { controller.publish }

    let(:product) { create(:product) }

    before do
      controller.instance_variable_set(:@product, product)
    end

    it { expect{ subject }.to change{ assigns(:product).state }.from('unpublished').to('published') }
  end

  describe '#my_products' do
    subject { controller.my_products }

    let(:product) { create(:product) }

    before do
      sign_in product.user
      subject
    end

    it { expect(assigns(:products).size).to eq(1) }
  end
end
