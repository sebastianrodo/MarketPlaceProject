require 'rails_helper'

RSpec.feature "Products", type: :feature do
  context 'visit users index page' do
    scenario 'visit products index page' do
      visit(products_path)
      expect(page).to have_current_path(products_path)
    end
  end

  context 'visit product show page' do
    before do
      create(:product, :published)
    end

    after do
      DatabaseCleaner.clean
    end

    scenario 'should display the product information' do
      visit(products_path)
      click_link('product_show')

      expect(page).to have_css("h1", :text => "PC MASTER RACE")
      expect(page).to have_css("h5", :text => "4gb RAM, 2TB SOLID DISK")
      expect(page).to have_css("h5", :text => "9")
      expect(page).to have_css("h4", :text => "5000000")
    end
  end

  context 'visit product edit page' do
    let(:user) { User.first }
    let(:product) { Product.first }

    before do
      create(:product)
      login_as(user, :scope => :user)
    end

    scenario 'should be successful' do
      visit(edit_product_path(product))
      within('#edit_product_form') do
        fill_in 'Name', with: 'Laptop Gamer'
      end

      click_button 'Save'
      expect(page).to have_content 'Product was successfully updated.'
    end

    scenario 'should be fail, without fill required fields, name can`t be blank' do
      visit(edit_product_path(product))
      within('#edit_product_form') do
        fill_in 'Name', with: ''
      end

      click_button 'Save'
      expect(page).to have_content "Name can't be blank"
    end

    scenario 'should be fail, quantity should be numeric' do
      visit(edit_product_path(product))
      within('#edit_product_form') do
        fill_in 'Quantity', with: 'hola'
      end

      click_button 'Save'
      expect(page).to have_content 'Quantity should be numeric'
    end

    scenario 'should be fail, price should be numeric' do
      visit(edit_product_path(product))
      within('#edit_product_form') do
        fill_in 'Price', with: 'hola'
      end

      click_button 'Save'
      expect(page).to have_content 'Price should be numeric'
    end
  end

  context 'visit product edit page, with other user' do
    let(:user) { User.first }
    let(:product) { Product.first }

    let(:user2) { User.create!(email: 'albert@example.com',
                                password: '12345678',
                                first_name: 'Albert',
                                last_name: 'Sanchez',
                                cellphone: 3022393687) }

    before do
      create(:product)
      login_as(user2, :scope => :user)
    end

    scenario 'should be fail, you are not the owner of this product' do
      visit(edit_product_path(product))
      within('#edit_product_form') do
        fill_in 'Price', with: 2
      end

      click_button 'Save'
      expect(page).to have_content 'You cannot do this action, you are not the owner of this product.'
    end
  end
end
