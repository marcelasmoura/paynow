require 'rails_helper'

describe 'Client Actions' do
  context 'Client can manage your business register' do
  	let!(:user) do
        User.create!(email: 'admin@codeplay.com.br',
                     password: 'thisisapassword',
                     password_confirmation: 'thisisapassword')
    end

    let!(:business_register) do
      BusinessRegister.create!(corporate_name: 'CodePlay',
                               billing_address: 'Rua da Estrela, 75',
                               state: 'Rio de Janeiro',
                               zip_code: '12129589',
                               billing_email: 'codeplay@codeplay.com',
                               cnpj: '123456789000125'
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
  	end

    xit 'Client can edit your business register' do
      
    end

    xit 'Client can require a new token' do
      click_on 'Visualizar Token'
      click_on 'Solicitar Novo Token'

      expect(page).to have_message('')
    end
  end
end