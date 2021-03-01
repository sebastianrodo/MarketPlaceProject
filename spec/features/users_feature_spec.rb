require 'rails_helper'

RSpec.feature "Users", type: :feature do
  let!(:user) { User.create!(email: 'test@example.com',
                            password: '12345678',
                            first_name: 'Fake_name',
                            last_name: 'Fake_last_name',
                            cellphone: 3022393687) }

  after do
    DatabaseCleaner.clean
  end

  context 'visit users index page' do
    scenario 'should be successful' do
      login_as(user, :scope => :user)
      visit(users_path)

      expect(page).to have_current_path(users_path)
    end

    scenario 'user not logged in' do
      visit(users_path)

      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context 'visit user show page' do
    scenario 'should display the user information' do
      login_as(user, :scope => :user)

      visit(users_path)

      click_link('user_show')

      expect(page).to have_css("h3", :text => "Fake_name")
      expect(page).to have_css("h3", :text => "Fake_last_name")
      expect(page).to have_css("h3", :text => "test@example.com")
      expect(page).to have_css("h6", :count => 5)
    end
  end

  context 'visit user edit page' do
    let(:user_attr_updated) {
        fill_in 'Last Name', with: 'Rodriguez'
        fill_in 'Cellphone', with: 3022393677
        fill_in 'Address', with: 'Calle 23'
        fill_in 'Current password', with: '12345678'
     }

    let!(:user2) { User.create!(email: 'shirlez@example.com',
                                password: '12345678',
                                first_name: 'Shirlez',
                                last_name: 'Ines',
                                cellphone: 300785259) }

    before do
      login_as(user, :scope => :user)
    end

    scenario 'should be successful' do
      visit(edit_user_registration_path)
      within('#edit_user_form') do
        fill_in 'First Name', with: 'Sebastian'
        user_attr_updated
      end
      click_button 'Update'

      expect(page).to have_content 'Your account has been updated successfully.'

    end

    scenario 'should be fail, without fill required fields, first name can`t be blank' do
      visit(edit_user_registration_path)
      within('#edit_user_form') do
        fill_in 'First Name', with: ''
        user_attr_updated
      end
      click_button 'Update'

      expect(page).to have_content "First name can't be blank"
    end

    scenario 'should be fail, current password invalid' do
      visit(edit_user_registration_path)
      within('#edit_user_form') do
        fill_in 'First Name', with: 'Sebastian'
        fill_in 'Current password', with: '1234567'
      end
      click_button 'Update'

      expect(page).to have_content "Current password is invalid"
    end

    scenario 'should be fail, email typed has already been taken' do
      visit(edit_user_registration_path)
      within('#edit_user_form') do
        fill_in 'Current password', with: '12345678'
        fill_in 'Email', with: 'shirlez@example.com'
      end
      click_button 'Update'

      expect(page).to have_content "Email has already been taken"
    end

    scenario 'should be fail, cellphone typed has already been taken' do
      visit(edit_user_registration_path)
      within('#edit_user_form') do
        fill_in 'Current password', with: '12345678'
        fill_in 'Cellphone', with: 300785259
      end
      click_button 'Update'

      expect(page).to have_content "Cellphone has already been taken"
    end

    scenario 'should be fail, you not are not this user' do
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
    let(:user_attr) {
        fill_in 'user_first_name', with: 'Shirlez'
        fill_in 'user_last_name', with: 'Rodriguez'
        fill_in 'user_cellphone', with: '3022393677'
        fill_in 'user_address', with: 'Calle 23'
        fill_in 'user_email', with: 'shirlez@example.com'
        fill_in 'user_password', with: '12345678'
     }

    # let!(:user2) { User.create!(email: 'shirlez@example.com',
    #                             password: '12345678',
    #                             first_name: 'Shirlez',
    #                             last_name: 'Ines',
    #                             cellphone: 300785259) }

    scenario 'should be successful' do
      visit(new_user_registration_path)
      within('#create_user_form') do
        user_attr
      end
      click_button 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'

    end

    scenario 'already signed in' do
      login_as(user, :scope => :user)
      visit(new_user_registration_path)


      expect(page).to have_content 'You are already signed in.'

    end

    scenario 'should be fail, without fill required fields, first name can`t be blank' do
      visit(new_user_registration_path)
      within('#create_user_form') do
        user_attr
        fill_in 'user_first_name', with: ''
      end
      click_button 'Sign up'

      expect(page).to have_content "First name can't be blank"
    end

    scenario 'should be fail, password have to minimum 8 characters' do
      visit(new_user_registration_path)
      within('#create_user_form') do
        user_attr
        fill_in 'user_password', with: '1234'
      end
      click_button 'Sign up'

      expect(page).to have_content "Password is too short (minimum is 8 characters)"
    end

    scenario 'should be fail, email typed has already been taken' do
      visit(new_user_registration_path)
      within('#create_user_form') do
        user_attr
        fill_in 'user_email', with: user.email
      end
      click_button 'Sign up'

      expect(page).to have_content "Email has already been taken"
    end

    scenario 'should be fail, cellphone typed has already been taken' do
      visit(new_user_registration_path)
      within('#create_user_form') do
        user_attr
        fill_in 'Cellphone', with: user.cellphone
      end
      click_button 'Sign up'

      expect(page).to have_content "Cellphone has already been taken"
    end
  end
end
