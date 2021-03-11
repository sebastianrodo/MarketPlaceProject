# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotifierMailer, type: :mailer do
  describe 'NotifierMailer' do
    subject(:mailer) { described_class.email(user, product).deliver_now }

    let(:product) { create(:product) }
    let(:user) { product.user }

    it 'renders the subject' do
      expect(mailer.subject).to eq('A new product has been published')
    end

    it 'renders the receiver email' do
      expect(mailer.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mailer.from).to eq(['from@example.com'])
    end
  end
end
