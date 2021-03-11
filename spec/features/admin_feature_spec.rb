# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin', type: :feature do
  let!(:admin_user) { create(:user, :admin) }

  let!(:normal_user) { create(:user) }

  after do
    DatabaseCleaner.clean
  end

  context 'visit dashboard page' do
    it 'is successful' do
      login_as(admin_user, scope: :user)
      visit(root_path)

      click_link('dashboard')

      expect(page).to have_current_path('/admin')
    end

    it 'is fail' do
      login_as(normal_user, scope: :user)
      visit('/admin')

      expect(page).to have_current_path(root_path)

      expect(page).to have_content 'You are not permitted to view this page'
    end
  end
end
