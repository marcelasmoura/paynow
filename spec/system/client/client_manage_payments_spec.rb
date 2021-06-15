require 'rails_helper'

describe 'Client can choose the payment method' do
  let!(:payment_method1) do
    PaymentMethod.create!(name: 'Pix',
                          charge_fee: 0.2,
                          minimum_fee: 2,
                          available: true,
                          payment_icon: {
                            io: File.open(Rails.root.join('spec', 'fixtures', 'banco.jpeg')),
                            filename: 'banco.jpeg'
                          })
  end

  let!(:payment_method2) do
    PaymentMethod.create!(name: 'Boleto',
                          charge_fee: 0.2,
                          minimum_fee: 2,
                          available: true,
                          payment_icon: {
                            io: File.open(Rails.root.join('spec', 'fixtures', 'banco.jpeg')),
                            filename: 'banco.jpeg'
                          })
  end

  let!(:payment_method3) do
    PaymentMethod.create!(name: 'MasterCard',
                          charge_fee: 0.2,
                          minimum_fee: 2,
                          available: true,
                          payment_icon: {
                            io: File.open(Rails.root.join('spec', 'fixtures', 'banco.jpeg')),
                            filename: 'banco.jpeg'
                          })
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

  context 'Add a new payment method' do
    it 'Pix' do
      visit client_home_index_path
      click_on 'Métodos de Pagamento'
      click_on 'Adicionar Novo Método de Pagamento'

      select 'Pix', from: 'Método de Pagamento'
      select '077 - Banco Inter S.A.', from: 'Banco'
      fill_in 'Token', with: 'SDPNtC2BbkCbNxsPEirO'
      fill_in 'Desconto', with: 10
      check 'Ativar'
      click_on 'Salvar'

      expect(page).to have_text('Métodos de Pagamento')
      expect(page).to have_link('Pix')
      expect(page).to have_link('Adicionar Novo Método de Pagamento')
    end

    it 'Creditcard' do
      visit client_home_index_path
      click_on 'Métodos de Pagamento'
      click_on 'Adicionar Novo Método de Pagamento'

      select 'MasterCard', from: 'Método de Pagamento'
      select '025 - Banco Alfa S.A.', from: 'Banco'
      fill_in 'Token', with: 'SDPNtC2BbkCbNxsPEirO'
      fill_in 'Desconto', with: 3
      check 'Ativar'
      click_on 'Salvar'

      expect(page).to have_text('Métodos de Pagamento')
      expect(page).to have_link('MasterCard')
      expect(page).to have_link('Adicionar Novo Método de Pagamento')
    end

    it 'Bank Slip' do
      visit client_home_index_path
      click_on 'Métodos de Pagamento'
      click_on 'Adicionar Novo Método de Pagamento'

      select 'Boleto', from: 'Método de Pagamento'
      select '025 - Banco Alfa S.A.', from: 'Banco'
      fill_in 'Token', with: 'SDPNtC2BbkCbNxsPEirO'
      fill_in 'Desconto', with: 2
      check 'Ativar'
      click_on 'Salvar'

      expect(page).to have_text('Métodos de Pagamento')
      expect(page).to have_link('Boleto')
      expect(page).to have_link('Adicionar Novo Método de Pagamento')
    end

    it 'See a details of Payment Option' do
      PaymentMethodOption.create!(payment_method: payment_method1, 
                                  cod_febraban: '077 - Banco Inter S.A.',
                                  discount: 2,
                                  token: 'SDPNtC2BbkCbNxsPEirO',
                                  active: true
                                  )

      visit client_home_index_path
      click_on 'Métodos de Pagamento'
      click_on payment_method1.name

      expect(page).to have_text('Pix')
      expect(page).to have_text('077 - Banco Inter S.A.')
      expect(page).to have_text('2')
      expect(page).to have_text('SDPNtC2BbkCbNxsPEirO')
      expect(page).to have_text('Disponível')
    end

    it 'can edit a payment option' do
      PaymentMethodOption.create!(payment_method: payment_method1, 
                                  cod_febraban: '077 - Banco Inter S.A.',
                                  discount: 2,
                                  token: 'SDPNtC2BbkCbNxsPEirO',
                                  active: true
                                  )

      visit client_home_index_path
      click_on 'Métodos de Pagamento'
      click_on payment_method1.name
      click_on 'Editar'

      select 'Boleto', from: 'Método de Pagamento'
      select '121 - Banco Agibank S.A.', from: 'Banco'
      fill_in 'Token', with: 'SDPNtC2BbkCbNxsPEirO'
      fill_in 'Desconto', with: 8
      uncheck 'Ativar'

      click_on 'Salvar'

      expect(page).to have_text('Boleto')
      expect(page).to have_text('121 - Banco Agibank S.A.')
      expect(page).to have_text('8')
      expect(page).to have_text('SDPNtC2BbkCbNxsPEirO')
      expect(page).to have_text('Indisponível')
    end

    it 'delete a payment option' do
      PaymentMethodOption.create!(payment_method: payment_method1, 
                                  cod_febraban: '077 - Banco Inter S.A.',
                                  discount: 2,
                                  token: 'SDPNtC2BbkCbNxsPEirO',
                                  active: true
                                  )

      visit client_home_index_path
      click_on 'Métodos de Pagamento'
      click_on payment_method1.name
      

      accept_alert do
        click_on 'Excluir'
      end

      expect(page).to_not have_link payment_method1.name
    end
  end
end