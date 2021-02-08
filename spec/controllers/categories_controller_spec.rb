require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  after do
    DatabaseCleaner.clean
  end

  describe 'GET #index' do
    subject { get :index }
    let(:user) { create(:user) }
    let(:category) { create(:category) }

    before do
      sign_in user
      category
      subject
    end

    it { expect(response).to have_http_status '200' }
    it { is_expected.to render_template :index }
    it { expect(assigns(:categories).size).to eq(1) }
  end

  describe 'GET #show' do
    subject { get :show, params: params }
    let(:params) { { id: category.id } }
    let(:user) { create(:user) }
    let(:category) { create(:category) }

    before do
      sign_in user
      subject
    end

    it { expect(response).to be_successful }
    it { expect(response).to have_http_status '200' }
    it { is_expected.to render_template :show }
  end

  describe 'GET #new' do
    subject { get :new }
    let(:user) { create(:user) }

    before do
      sign_in user
      subject
    end

    it { expect(assigns(:category)).to_not be_nil }
    it { expect(assigns(:category)).to be_a_new(Category) }
    it { expect(response).to be_successful }
    it { expect(response).to have_http_status '200' }
    it { is_expected.to render_template :new }
  end
end
