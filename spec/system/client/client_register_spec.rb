require 'rails_helper'

describe 'Client Actions' do
	it 'Frist client create a count and become a Client/Admin and create a businesse' do
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

	xit 'Client/Admin allows access from other clients' do
		
	end

	xit 'Client/Admin denies access to other customers' do
		
	end
end