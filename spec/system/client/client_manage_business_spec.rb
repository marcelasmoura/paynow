require 'rails_helper'

describe 'Client Actions' do
  context 'Client can manage your business register' do
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

  	let!(:user) do
        User.create!(email: 'admin@codeplay.com.br',
                     password: 'thisisapassword',
                     password_confirmation: 'thisisapassword',
                     business_register_id: business_register.id
                     )
    end

    before do
      sign_in user
    end

  	it 'Client can see your business register' do
      visit client_home_index_path
  		click_on 'Informações da Empresa'

      expect(page).to have_text('CodePlay')
      expect(page).to have_text('123456789000125')
      expect(page).to have_text('Rua da Estrela, 75')
      expect(page).to have_text('Rio de Janeiro')
      expect(page).to have_text('12129589')
      expect(page).to have_text('codeplay@codeplay.com')
      expect(page).to have_text('codeplay.com.br')
  	end

    it 'Client can edit your business register' do
      visit client_home_index_path
      click_on 'Informações da Empresa'
      click_on 'Editar'

      fill_in 'CNPJ', with: '123456789000258'
      fill_in 'Razão Social', with: 'GloboPlay'
      fill_in 'Endereço de Faturamento', with: 'Rua da Lua, 75'
      fill_in 'Estado', with: 'São Paulo'
      fill_in 'CEP', with: '12129677'
      fill_in 'Email de Faturamento', with: 'globoplay@globoplay.com'
      fill_in 'Dominio para Futuros Usuários', with: 'globoplay.com.br'

      click_on 'Salvar'

      expect(page).to have_text('GloboPlay')
      expect(page).to have_text('123456789000258')
      expect(page).to have_text('Rua da Lua, 75')
      expect(page).to have_text('São Paulo')
      expect(page).to have_text('12129677')
      expect(page).to have_text('globoplay@globoplay.com')
      expect(page).to have_text('globoplay.com.br')
    end

    it 'Can see business token' do
      visit client_home_index_path
      click_on 'Visualizar Token'

      expect(page).to have_content(business_register.token)
    end

    it 'Client can require a new token' do
      visit client_home_index_path
      old_token = business_register.token
      click_on 'Visualizar Token'
      click_on 'Solicitar Novo Token'

      business_register.reload

      expect(page).to have_content(business_register.token)
      expect(business_register.token).to_not eq(old_token)
    end
  end
end