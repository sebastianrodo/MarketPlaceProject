# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  subject(:product) do
    described_class.new(
      name: 'Cellphone',
      description: '64 GB',
      quantity: 34,
      price: 800_000,
      user_id: User.last.id,
      category_id: Category.last.id
    )
  end

  before do
    User.create(
      first_name: 'Shirlez',
      last_name: 'Conrado',
      email: 'shirlez@gmail.com',
      password: '12345678',
      address: 'Street 23',
      cellphone: '3032393677'
    )

    Category.create(name: 'technology')
  end

  after do
    DatabaseCleaner.clean
  end

  context 'with associations' do
    it { expect(product).to have_many(:images) }

    it {
      expect(product).to belong_to(:user).class_name('User')
                                         .with_foreign_key('user_id')
    }

    it {
      expect(product).to belong_to(:category).class_name('Category')
                                             .with_foreign_key('category_id')
    }
  end

  context 'with enum' do
    it do
      expect(product).to define_enum_for(:state)
        .with_values(%i[published archived unpublished])
    end
  end

  context 'with accepts nested attributes' do
    it {
      expect(product).to accept_nested_attributes_for(:images)
        .allow_destroy(true)
    }
  end

  it 'product with valid attributes' do
    expect(product).to be_valid
  end

  it 'is invalid not have a name' do
    product.name = ''
    expect(product).not_to be_valid
  end

  it 'is invalid not have a description' do
    product.description = ''
    expect(product).not_to be_valid
  end

  it 'is invalid not have a quantity' do
    product.quantity = nil
    expect(product).not_to be_valid
  end

  it 'is invalid not have a price' do
    product.price = nil
    expect(product).not_to be_valid
  end

  it 'is invalid, quantity just should have numbers' do
    product.quantity = 'hola'
    expect(product).not_to be_valid
  end

  it 'is invalid, price just should have numbers' do
    product.price = 'hola'
    expect(product).not_to be_valid
  end
end
