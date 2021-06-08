require 'rails_helper'

describe 'Admin Actions' do
	context 'Admin manage payment methods' do
    let!(:user) do
      User.create!(email: 'admin@paynow.com.br',
                   password: 'thisisapassword',
                   password_confirmation: 'thisisapassword')
    end

    before do
      sign_in user
    end
  
    it 'Admin can add a new payment method' do
      visit admin_home_index_path
      click_on 'Métodos de Pagamento'
      click_on 'Novo Método de Pagamento'

      fill_in 'Nome', with: 'Pix'
      attach_file 'Ícone', Rails.root.join('spec', 'fixtures', 'pix.jpeg')
      fill_in 'Taxa de Cobrança', with: '0,2%'
      fill_in 'Taxa Mínima', with: '0,2%'
      check 'Ativar'
      click_on 'Adicionar Método de Pagamento'

      expect(page).to have_text('Métodos de Pagamento')
      expect(page).to have_link('Pix')

    end

    xit 'Admin can delete a payment method' do
      
    end

    xit 'Admin can see details of a especifique payment method' do
      
    end

    xit 'Admin can see edit a payment method' do
      
    end

    xit 'Admin can turn off a payment method' do
      
    end
  end
end