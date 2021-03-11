# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::ProductsController, type: :controller do
  after do
    DatabaseCleaner.clean
  end

  describe 'GET #index' do
    subject { get :index }

    let(:product) { create(:product) }

    before do
      sign_in product.user
      subject
    end

    it { expect(assigns(:products).size).to eq(1) }
  end
end
