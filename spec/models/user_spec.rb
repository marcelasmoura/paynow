require 'rails_helper'

describe User, type: :model do
  context 'Create user roles according the email domain' do
    it 'if email domain belongs to paynow' do
      user = User.create!(email:'user@paynow.com.br', 
                   password:'thisisapassword', 
                   password_confirmation: 'thisisapassword')

      expect(user).to be_super_admin
    end

    it 'email domain belong to codeplay as a first registered' do
      user = User.create!(email:'user@codeplay.com.br', 
                   password:'thisisapassword', 
                   password_confirmation: 'thisisapassword')

      expect(user).to be_client_admin
    end

    it 'email domain belong to codeplay' do
     User.create!(email:'user@codeplay.com.br', 
                   password:'thisisapassword', 
                   password_confirmation: 'thisisapassword')

      user = User.create!(email:'user2@codeplay.com.br', 
                   password:'thisisapassword', 
                   password_confirmation: 'thisisapassword')

      expect(user).to be_client
    end

  end
end
