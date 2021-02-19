# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) do
    described_class.new(first_name: 'Sebastian',
                        last_name: 'Rodriguez',
                        email: 'seanrito@gmail.com',
                        password: '12345678',
                        address: 'Street 21',
                        cellphone: '3022393677')
  end

  before do
    described_class.create(
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

  context 'with associations valid' do
    it { expect(user).to have_many(:products) }
  end

  it 'user with valid attributes' do
    expect(user).to be_valid
  end

  it 'is invalid not have a first_name' do
    user.first_name = ''
    expect(user).not_to be_valid
  end

  it 'is invalid not have a last_name' do
    user.last_name = ''
    expect(user).not_to be_valid
  end

  it 'is invalid not have an email' do
    user.email = ''
    expect(user).not_to be_valid
  end

  it 'Expect fail, email already taken' do
    user.email = 'shirlez@gmail.com'
    expect(user).not_to be_valid
  end

  it 'is invalid, cellphone just should have numbers' do
    user.cellphone = 'colombia'
    expect(user).not_to be_valid
  end

  it 'Expect fail, cellphone already taken' do
    user.cellphone = '3032393677'
    expect(user).not_to be_valid
  end

  it 'validate password length' do
    expect(user).to validate_length_of(:password)
      .is_at_least(8)
      .on(:create)
  end
end
