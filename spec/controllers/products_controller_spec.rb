require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  after do
    DatabaseCleaner.clean
  end

  describe 'GET #index' do
    subject { get :index }

    context 'expect to be successfully, render index' do
      before do
        FactoryBot.create_list(:product, 3)
        subject
      end

      it { expect(response).to have_http_status '200' }
      it { is_expected.to render_template :index }
      it { expect(assigns(:products).size).to eq(3) }
    end
  end
end
