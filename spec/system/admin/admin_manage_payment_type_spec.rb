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
      attach_file 'Ícone', Rails.root.join('spec', 'fixtures', 'banco.jpeg')
      fill_in 'Taxa de Cobrança - %', with: '0.2'
      fill_in 'Taxa Mínima - R$', with: '0.2'
      check 'Ativar'
      click_on 'Salvar'

      expect(page).to have_text('Métodos de Pagamento')
      expect(page).to have_link('Pix')

    end

    it 'Field name cannot be empty' do
      visit admin_home_index_path
      click_on 'Métodos de Pagamento'
      click_on 'Novo Método de Pagamento'

      fill_in 'Nome', with: ''
      attach_file 'Ícone', Rails.root.join('spec', 'fixtures', 'banco.jpeg')
      fill_in 'Taxa de Cobrança - %', with: '0.2'
      fill_in 'Taxa Mínima - R$', with: '0.2'
      check 'Ativar'
      click_on 'Salvar'

      expect(page).to have_text('Nome não pode ficar em branco')
    end

    it 'Admin can see details of a especifique payment method' do
      pm = PaymentMethod.create!(name: 'Pix',
                                charge_fee: 0.2,
                                minimum_fee: 2,
                                available: true,
                                payment_icon: {
                                  io: File.open(Rails.root.join('spec', 'fixtures', 'banco.jpeg')),
                                  filename: 'banco.jpeg'
                                })
      visit admin_home_index_path
      click_on 'Métodos de Pagamento'
      click_on pm.name

      expect(page).to have_text('Pix')
      expect(page).to have_content('0,2')
      expect(page).to have_content('2')
      expect(page).to have_content('Disponível')
      expect(page).to have_css('[src$="banco.jpeg"]')
    end

    it 'Admin can edit a payment method' do
      pm = PaymentMethod.create!(name: 'Pix',
                                charge_fee: 0.2,
                                minimum_fee: 0.2,
                                available: true,
                                payment_icon: {
                                  io: File.open(Rails.root.join('spec', 'fixtures', 'banco.jpeg')),
                                  filename: 'banco.jpeg'
                                })
      visit admin_home_index_path
      click_on 'Métodos de Pagamento'
      click_on pm.name
      click_on 'Editar'

      fill_in 'Nome', with: 'Banco Marrom'
      attach_file 'Ícone', Rails.root.join('spec', 'fixtures', 'banco.jpeg')
      fill_in 'Taxa de Cobrança', with: '0.8'
      fill_in 'Taxa Mínima', with: '9'
      uncheck 'Ativar'
      click_on 'Salvar'

      expect(page).to have_text('Banco Marrom')
      expect(page).to have_content('0,8')
      expect(page).to have_content(9)
      expect(page).to have_content('Indisponível')
      expect(page).to have_css('[src$="banco.jpeg"]')

    end

    it 'Admin can delete a payment method' do
      pm = PaymentMethod.create!(name: 'Pix',
                                charge_fee: 0.2,
                                minimum_fee: 0.2,
                                available: true,
                                payment_icon: {
                                  io: File.open(Rails.root.join('spec', 'fixtures', 'banco.jpeg')),
                                  filename: 'banco.jpeg'
                                })
      visit admin_home_index_path
      click_on 'Métodos de Pagamento'
      click_on pm.name
      
      accept_alert do
        click_on 'Excluir'
      end

      expect(page).to_not have_content('Pix')
    end
  end
end