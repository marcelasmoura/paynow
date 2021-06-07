require 'rails_helper'

describe 'Admin Actions' do
	context 'Admin create a count' do
	  it 'successfully' do
      visit root_path
      click_on 'Entar'
      click_on 'Criar Conta'

      fill_in 'Email', with: 'admin@paynow.com.br'
      fill_in 'Senha', with: 'umasenhadoadmin'
      fill_in 'Confirmação de senha', with: 'umasenhadoadmin'
      click_on 'Criar Conta'

      expect(page).to have_text('Home do Admin')
      expect(page).to have_text('admin@paynow.com.br')
      expect(page).to_not have_link('Entar')
      expect(page).to have_link('Sair')
		end
	end
end