require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { Product.new(
    name: 'Cellphone',
    description: '64 GB',
    quantity: 34,
    price: 800000,
    user_id: User.last.id,
    category_id: Category.last.id
    ) }

  before do
    user = User.create(
      first_name: 'Shirlez',
      last_name: 'Conrado',
      email: 'shirlez@gmail.com',
      password: '12345678',
      address: 'Street 23',
      cellphone: '3032393677'
      )

    category = Category.create(name: 'technology')
  end

  after do
    DatabaseCleaner.clean
  end

  context 'associations' do
    it { should have_many(:images) }
    it { should belong_to(:user).class_name('User').
          with_foreign_key('user_id') }
    it { should belong_to(:category).class_name('Category').
      with_foreign_key('category_id') }
  end

  context 'enum' do
    it do
      should define_enum_for(:state).
        with_values([:published, :archived, :unpublished])
    end
  end

  context 'accepts nested attributes' do
    it { should accept_nested_attributes_for(:images).
          allow_destroy(true) }
  end

  it 'product with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is invalid not have a name' do
    subject.name = ''
    expect(subject).not_to be_valid
  end

  it 'is invalid not have a first_name' do
    subject.description = ''
    expect(subject).not_to be_valid
  end

  it 'is invalid not have a first_name' do
    subject.quantity = nil
    expect(subject).not_to be_valid
  end

  it 'is invalid not have a first_name' do
    subject.price = nil
    expect(subject).not_to be_valid
  end

  it 'is invalid, quantity just should have numbers' do
    subject.quantity = 'hola'
    expect(subject).not_to be_valid
  end

  it 'is invalid, price just should have numbers' do
    subject.price = 'hola'
    expect(subject).not_to be_valid
  end
end
