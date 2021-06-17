require 'rails_helper'

describe 'Admin can' do
    let!(:user) do
      User.create!(email: 'admin@paynow.com.br',
                   password: 'thisisapassword',
                   password_confirmation: 'thisisapassword')
      end

    let!(:user2) do
      User.create!(email: 'admin2@paynow.com.br',
                   password: 'thisisapassword',
                   password_confirmation: 'thisisapassword')
      end

    let!(:business_register) do
      BusinessRegister.create!(corporate_name: 'CodePlay',
                               billing_address: 'Rua da Estrela, 75',
                               state: 'Rio de Janeiro',
                               zip_code: '12129589',
                               billing_email: 'codeplay@codeplay.com',
                               cnpj: '123456789000125',
                               domain: 'codeplay.com.br'
                               )
     end

    let!(:client_user) do
      User.create!(email: 'admin@codeplay.com.br',
                   password: 'thisisapassword',
                   password_confirmation: 'thisisapassword',
                   business_register_id: business_register.id
                   )
     end

    let!(:business_register2) do
      BusinessRegister.create!(corporate_name: 'GloboPlay',
                               billing_address: 'Rua da Estrela, 75',
                               state: 'Rio de Janeiro',
                               zip_code: '12129589',
                               billing_email: 'codeplay@codeplay.com',
                               cnpj: '123456789000125',
                               domain: 'globoplay.com.br'
                               )
      end

    before do
      sign_in user
    end

    it 'see a list of clients' do
        visit admin_home_index_path
        click_on 'Clientes'
        click_on business_register.corporate_name

      expect(page).to have_text('CodePlay')
      expect(page).to have_text('123456789000125')
      expect(page).to have_text('Rua da Estrela, 75')
      expect(page).to have_text('Rio de Janeiro')
      expect(page).to have_text('12129589')
      expect(page).to have_text('codeplay@codeplay.com')
      expect(page).to have_text('codeplay.com.br')
      expect(page).to have_button('Gerar Novo Token')
      expect(page).to have_link('Suspender Conta')
    end

    it 'can generate a new token for client' do
      visit admin_home_index_path
      
      old_token = business_register.token

      click_on 'Clientes'
      click_on business_register.corporate_name
      click_on 'Gerar Novo Token'

      business_register.reload

      expect(page).to have_content(business_register.token)
      expect(business_register.token).to_not eq(old_token)
    end

    it 'edit client data' do
      visit admin_home_index_path
      click_on 'Clientes'
      click_on business_register.corporate_name
      click_on 'Editar'

      fill_in 'CNPJ', with: '123456789000258'
      fill_in 'Razão Social', with: 'GloboPlay'
      fill_in 'Endereço de Faturamento', with: 'Rua da Lua, 75'
      fill_in 'Estado', with: 'São Paulo'
      fill_in 'CEP', with: '12129677'
      fill_in 'Email de Faturamento', with: 'globoplay@globoplay.com'
      fill_in 'Dominio para Futuros Usuários', with: 'globoplay2.com.br'

      click_on 'Salvar'

      expect(page).to have_text('GloboPlay')
      expect(page).to have_text('123456789000258')
      expect(page).to have_text('Rua da Lua, 75')
      expect(page).to have_text('São Paulo')
      expect(page).to have_text('12129677')
      expect(page).to have_text('globoplay@globoplay.com')
      expect(page).to have_text('globoplay2.com.br')
    end

    xit 'requests a suspend a client account' do
      visit admin_home_index_path
      click_on 'Clientes'
      click_on business_register.corporate_name
      click_on 'Suspender Conta'

      accept_alert do
        click_on 'Solicitar'
      end

      visit admin_home_index_path
      click_on 'Clientes'
      expect(page).to have_content("#{business_register.corporate_name} Confirmar Suspensão")
      expect(page).to have_link(business_register2.corporate_name)
    end

    xit 'suspend a client account' do
      before do
        sign_in user2
      end

      expect(page).to have_content('Solicitação de Suspensão Enviada')
      visit admin_home_index_path
      click_on 'Clientes'
      click_on business_register.corporate_name
      click_on 'Suspender Conta'

      accept_alert do
        click_on 'Suspender'
      end

      expect(page).to have_content('Cliente Suspenso')
      visit admin_home_index_path
      click_on 'Clientes'
      expect(page).to have_content("#{business_register.corporate_name} Cliente Suspenso")
      expect(page).to have_link(business_register2.corporate_name)
    end
end