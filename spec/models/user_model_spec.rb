require 'rails_helper'

RSpec.describe User, type: :model do
  subject { User.new(first_name: 'Sebastian',
    last_name: 'Rodriguez',
    email: 'seanrito@gmail.com',
    password: '12345678',
    address: 'Street 21',
    cellphone: '3022393677') }

  before do
    User.create(
      first_name: 'Shirlez',
      last_name: 'Conrado',
      email: 'shirlez@gmail.com',
      password: '12345678',
      address: 'Street 23',
      cellphone: '3032393677'
      )
  end

  after do
    DatabaseCleaner.clean
  end

  context "associations" do
    it { should have_many(:products) }
  end

  it 'user with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is invalid not have a first_name' do
    subject.first_name = ''
    expect(subject).not_to be_valid
  end

  it 'is invalid not have a last_name' do
    subject.last_name = ''
    expect(subject).not_to be_valid
  end

  it 'is invalid not have an email' do
    subject.email = ''
    expect(subject).not_to be_valid
  end

  it 'Expect fail, email already taken' do
    subject.email = 'shirlez@gmail.com'
    expect(subject).not_to be_valid
  end

  it 'is invalid, cellphone just should have numbers' do
    subject.cellphone = 'colombia'
    expect(subject).not_to be_valid
  end

  it 'Expect fail, cellphone already taken' do
    subject.cellphone = '3032393677'
    expect(subject).not_to be_valid
  end

  it 'validate password length' do
    should validate_length_of(:password).
      is_at_least(8).
      on(:create)
  end
end
