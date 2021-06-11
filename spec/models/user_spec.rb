require 'rails_helper'

describe User, type: :model do
  context 'Scopes' do
    it 'Filter panding users' do
      client_admin = User.create!(email:'user@codeplay.com.br', 
                                  password:'thisisapassword', 
                                  password_confirmation: 'thisisapassword')

      client = User.create!(email:'user2@codeplay.com.br', 
                            password:'thisisapassword', 
                            password_confirmation: 'thisisapassword')

      expect(User.pending).to include(client)
      expect(User.pending).to_not include(client_admin)
      expect(User.pending.count).to eq(1)
    end

    it 'Filter users by domain' do
      client_admin = User.create!(email: 'admin@codeplay.com.br',
                                  password: 'thisisapassword',
                                  password_confirmation: 'thisisapassword')

      client = User.create!(email: 'other_client@codeplay.com.br',
                            password: 'thisisapassword',
                            password_confirmation: 'thisisapassword') 

      client_admin2 = User.create!(email: 'admin@globoplay.com.br',
                            password: 'thisisapassword',
                            password_confirmation: 'thisisapassword')

      client2 = User.create!(email: 'other_client@globoplay.com.br',
                            password: 'thisisapassword',
                            password_confirmation: 'thisisapassword') 

      expect(User.by_domain('codeplay.com.br')).to match([client_admin, client])
      expect(User.by_domain('codeplay.com.br')).to_not match([client_admin2, client2])
      expect(User.by_domain('globoplay.com.br')).to match([client_admin2, client2])
      expect(User.by_domain('globoplay.com.br')).to_not match([client_admin, client])
    end
  end

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

  context 'User needs a permission' do
    it 'If user was a super_admim' do
      user = User.create!(email:'user@paynow.com.br', 
                   password:'thisisapassword', 
                   password_confirmation: 'thisisapassword')

      expect(user.pending).to eq false
    end

    it 'If user was a client_admin' do
      user = User.create!(email:'user@codeplay.com.br', 
                   password:'thisisapassword', 
                   password_confirmation: 'thisisapassword')

      expect(user.pending).to eq false
    end

    it 'If user was a client' do
      User.create!(email:'user@codeplay.com.br', 
                   password:'thisisapassword', 
                   password_confirmation: 'thisisapassword')

      user = User.create!(email:'user2@codeplay.com.br', 
                   password:'thisisapassword', 
                   password_confirmation: 'thisisapassword')

      expect(user.pending).to eq true
    end
  end
end
