# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Products::ArchivesController, type: :controller do
  after do
    DatabaseCleaner.clean
  end

  describe 'GET #update' do
    subject { patch :update, params: params }

    let(:product) { create(:product, :published) }

    let(:params) do
      { product_id: product.id }
    end

    before do
      sign_in product.user
    end

    it { expect { subject }.to change { product.reload.state }.from('published').to('archived') }
  end
end
