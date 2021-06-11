require 'rails_helper'

describe 'Client Actions' do
  context 'Client/Admin and Client can register thenselves' do
  	it 'First client create account and become a Client/Admin and create a business' do
  	  visit root_path
      click_on 'Entar'
      click_on 'Criar Conta'

      fill_in 'Email', with: 'admin@codeplay.com.br'
      fill_in 'Senha', with: 'umasenhadoclientadmin'
      fill_in 'Confirmação de senha', with: 'umasenhadoclientadmin'
      click_on 'Criar Conta'


      #Add business
      fill_in 'CNPJ', with: '123456789000125'
      fill_in 'Razão Social', with: 'CodePlay'
      fill_in 'Endereço de Faturamento', with: 'Rua da Estrela, 75'
      fill_in 'Estado', with: 'Rio de Janeiro'
      fill_in 'CEP', with: '12129589'
      fill_in 'Email de Faturamento', with: 'codeplay@codeplay.com'
      fill_in 'Dominio para Futuros Usuários', with: 'codeplay.com.br'

      click_on 'Salvar'

      expect(page).to have_text('Home do Cliente')
      expect(page).to have_text('admin@codeplay.com.br')
      expect(page).to_not have_link('Entar')
      expect(page).to have_link('Sair')	

  	end
    
  	it 'Others clients create a count' do
      User.create!(email: 'cliente@codeplay.com.br',
                     password: 'thisisapassword',
                     password_confirmation: 'thisisapassword')

  		visit root_path
      click_on 'Entar'
      click_on 'Criar Conta'

      fill_in 'Email', with: 'cliente2@codeplay.com.br'
      fill_in 'Senha', with: 'umasenhadoclient'
      fill_in 'Confirmação de senha', with: 'umasenhadoclient'

      click_on 'Criar Conta'

      expect(page).to have_text('Home do Cliente')
      expect(page).to have_text('Aguardando liberação de acesso!')
  	end
  end

  context 'Client/Admin can manage access of new clients users' do
  	it 'allow access to clients of its business' do
      business = BusinessRegister.create!(corporate_name: 'CodePlay',
                                        billing_address: 'Rua A, 20',
                                        state: 'São Paulo',
                                        zip_code: '25254282',
                                        billing_email: 'codeplay@codeplay.com.br',
                                        cnpj: '123456000156',
                                        domain: 'codeplay.com.br'
                                       )

  		client_admin = User.create!(email: 'admin@codeplay.com.br',
                                  password: 'thisisapassword',
                                  password_confirmation: 'thisisapassword',
                                  business_register_id: business.id
                                  )

      client = User.create!(email: 'other_client@codeplay.com.br',
                            password: 'thisisapassword',
                            password_confirmation: 'thisisapassword')

      business2 = BusinessRegister.create!(corporate_name: 'GloboPlay',
                                        billing_address: 'Rua A, 20',
                                        state: 'São Paulo',
                                        zip_code: '25254282',
                                        billing_email: 'globoplay@globoplay.com.br',
                                        cnpj: '123456000156',
                                        domain: 'globoplay.com.br'
                                       )

      client_admin2 = User.create!(email: 'admin@globoplay.com.br',
                            password: 'thisisapassword',
                            password_confirmation: 'thisisapassword')


      client2 = User.create!(email: 'other_client@globoplay.com.br',
                            password: 'thisisapassword',
                            password_confirmation: 'thisisapassword') 


      sign_in client_admin     

      visit client_home_index_path
      click_on 'Avaliar Acessos'
      click_on 'Permitir'

      expect(page).to_not have_text client.email
      expect(page).to_not have_text client2.email
      expect(page).to_not have_text client_admin2.email

      click_on 'Sair'
      click_on 'Entar'
      fill_in 'Email', with: client.email
      fill_in 'Senha', with: client.password
      click_on 'Log in'

      expect(page).to_not have_text('Aguardando liberação de acesso!')
      expect(page).to have_link('Informações da Empresa')
  	end

  	it 'deny access to clients of its business' do
      business = BusinessRegister.create!(corporate_name: 'CodePlay',
                                        billing_address: 'Rua A, 20',
                                        state: 'São Paulo',
                                        zip_code: '25254282',
                                        billing_email: 'codeplay@codeplay.com.br',
                                        cnpj: '123456000156',
                                        domain: 'codeplay.com.br'
                                       )

  		client_admin = User.create!(email: 'admin@codeplay.com.br',
                                  password: 'thisisapassword',
                                  password_confirmation: 'thisisapassword',
                                  business_register_id: business.id
                                  )

      client = User.create!(email: 'other_client@codeplay.com.br',
                            password: 'thisisapassword',
                            password_confirmation: 'thisisapassword') 
      sign_in client_admin     

      visit client_home_index_path
      click_on 'Avaliar Acessos'
      click_on 'Negar'

      expect(page).to_not have_text client.email
    end

  end
end