# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :feature do
  let!(:user) do
    User.create!(email: 'test@example.com',
                 password: '12345678',
                 first_name: 'Fake_name',
                 last_name: 'Fake_last_name',
                 cellphone: 3_022_393_687)
  end

  after do
    DatabaseCleaner.clean
  end

  context 'when visits users index page' do
    it 'is successful' do
      login_as(user, scope: :user)
      visit(users_path)

      expect(page).to have_current_path(users_path)
    end

    it 'user not logged in' do
      visit(users_path)

      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context 'when visits user show page' do
    it 'displays user information' do
      login_as(user, scope: :user)

      visit(users_path)

      click_link('user_show')

      expect(page).to have_css('h3', text: 'Fake_name')
      expect(page).to have_css('h3', text: 'Fake_last_name')
      expect(page).to have_css('h3', text: 'test@example.com')
      expect(page).to have_css('h6', count: 5)
    end
  end

  context 'when visits user edit page' do
    let(:user_attr_updated) do
      fill_in 'Last Name', with: 'Rodriguez'
      fill_in 'Cellphone', with: 3_022_393_677
      fill_in 'Address', with: 'Calle 23'
      fill_in 'Current password', with: '12345678'
    end

    let!(:user2) do
      User.create!(email: 'shirlez@example.com',
                   password: '12345678',
                   first_name: 'Shirlez',
                   last_name: 'Ines',
                   cellphone: 300_785_259)
    end

    before do
      login_as(user, scope: :user)
    end

    it 'is successful' do
      visit(edit_user_registration_path)
      within('#edit_user_form') do
        fill_in 'First Name', with: 'Sebastian'
        user_attr_updated
      end
      click_button 'Update'

      expect(page).to have_content 'Your account has been updated successfully.'
    end

    it 'without fill required fields, first name can`t be blank' do
      visit(edit_user_registration_path)
      within('#edit_user_form') do
        fill_in 'First Name', with: ''
        user_attr_updated
      end
      click_button 'Update'

      expect(page).to have_content "First name can't be blank"
    end

    it 'is fail, current password invalid' do
      visit(edit_user_registration_path)
      within('#edit_user_form') do
        fill_in 'First Name', with: 'Sebastian'
        fill_in 'Current password', with: '1234567'
      end
      click_button 'Update'

      expect(page).to have_content 'Current password is invalid'
    end

    it 'is fail, email typed has already been taken' do
      visit(edit_user_registration_path)
      within('#edit_user_form') do
        fill_in 'Current password', with: '12345678'
        fill_in 'Email', with: 'shirlez@example.com'
      end
      click_button 'Update'

      expect(page).to have_content 'Email has already been taken'
    end

    it 'is fail, cellphone typed has already been taken' do
      visit(edit_user_registration_path)
      within('#edit_user_form') do
        fill_in 'Current password', with: '12345678'
        fill_in 'Cellphone', with: 300_785_259
      end
      click_button 'Update'

      expect(page).to have_content 'Cellphone has already been taken'
    end

    it 'is fail, you not are not this user' do
      visit(edit_user_path(user2))
      within('#edit_user_form') do
        fill_in 'First Name', with: 'Ines'
      end
      click_button 'Save'

      expect(page).to have_content 'You cannot do this action, this account does not belong to you.'
    end
  end

  context 'visit user create page' do
    let(:user) { create(:user) }
    let(:user_attr) do
      fill_in 'user_first_name', with: 'Shirlez'
      fill_in 'user_last_name', with: 'Rodriguez'
      fill_in 'user_cellphone', with: '3022393677'
      fill_in 'user_address', with: 'Calle 23'
      fill_in 'user_email', with: 'shirlez@example.com'
      fill_in 'user_password', with: '12345678'
    end

    it 'is successful' do
      visit(new_user_registration_path)
      within('#create_user_form') do
        user_attr
      end
      click_button 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    it 'already signed in' do
      login_as(user, scope: :user)
      visit(new_user_registration_path)

      expect(page).to have_content 'You are already signed in.'
    end

    it 'is fail, without fill required fields, first name can`t be blank' do
      visit(new_user_registration_path)
      within('#create_user_form') do
        user_attr
        fill_in 'user_first_name', with: ''
      end
      click_button 'Sign up'

      expect(page).to have_content "First name can't be blank"
    end

    it 'is fail, password have to minimum 8 characters' do
      visit(new_user_registration_path)
      within('#create_user_form') do
        user_attr
        fill_in 'user_password', with: '1234'
      end
      click_button 'Sign up'

      expect(page).to have_content 'Password is too short (minimum is 8 characters)'
    end

    it 'is fail, email typed has already been taken' do
      visit(new_user_registration_path)
      within('#create_user_form') do
        user_attr
        fill_in 'user_email', with: user.email
      end
      click_button 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end

    it 'is fail, cellphone typed has already been taken' do
      visit(new_user_registration_path)
      within('#create_user_form') do
        user_attr
        fill_in 'Cellphone', with: user.cellphone
      end
      click_button 'Sign up'

      expect(page).to have_content 'Cellphone has already been taken'
    end
  end
end
