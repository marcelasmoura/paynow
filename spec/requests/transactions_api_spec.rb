require 'rails_helper'

describe 'PayNow API' do
  context 'POST /api/v1/customers' do
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

    let!(:payment_method) do
      PaymentMethod.create!(name: 'Pix',
                            charge_fee: 0.2,
                            minimum_fee: 2,
                            available: true,
                            payment_icon: {
                              io: File.open(Rails.root.join('spec', 'fixtures', 'banco.jpeg')),
                              filename: 'banco.jpeg'
                            })
    end

    let!(:payment_method_option) do
      PaymentMethodOption.create!(payment_method: payment_method, 
                                  cod_febraban: '077 - Banco Inter S.A.',
                                  discount: 10,
                                  token: 'SDPNtC2BbkCbNxsPEirO',
                                  active: true
                                  )
    end

    let!(:card_payment_method) do
      PaymentMethod.create!(name: 'CreditCard',
                            charge_fee: 0.2,
                            minimum_fee: 2,
                            available: true,
                            payment_type: :card,
                            payment_icon: {
                              io: File.open(Rails.root.join('spec', 'fixtures', 'banco.jpeg')),
                              filename: 'banco.jpeg'
                            })
    end

    let!(:card_payment_option) do
      PaymentMethodOption.create!(payment_method: card_payment_method, 
                                  cod_febraban: '077 - Banco Inter S.A.',
                                  discount: 10,
                                  token: 'SDPNtC2BbkCbNxsPEirO',
                                  active: true
                                  )
    end
    
    let!(:bank_slip_payment_method) do
      PaymentMethod.create!(name: 'Boleto',
                            charge_fee: 0.2,
                            minimum_fee: 2,
                            available: true,
                            payment_icon: {
                              io: File.open(Rails.root.join('spec', 'fixtures', 'banco.jpeg')),
                              filename: 'banco.jpeg'
                            })
    end
    
    let!(:bank_slip_payment_option) do
      PaymentMethodOption.create!(payment_method: bank_slip_payment_method, 
                                  cod_febraban: '077 - Banco Inter S.A.',
                                  discount: 10,
                                  token: 'SDPNtC2BbkCbNxsPEirO',
                                  active: true
                                  )
    end

    let!(:product) do
      Product.create!(name: 'Curso A',
                      price: 50.00,
                      payment_method_option_id: payment_method_option.id)
    end

    let!(:customer) do
      Customer.create!(full_name: 'João da Silva',
                       cpf: '12345678912')
    end

    let!(:register_customer) do
      RegisterCustomer.create!(customer_id: customer.id,
                               business_register_id: business_register.id)
    end

    it 'generate a pix transaction' do
      post '/api/v1/transactions', params: {
        business_token: business_register.token,
        payment_option_token: payment_method_option.token,
        product_token: product.token,
        customer_token: customer.token
      }

      expect(response).to have_http_status(201)
      transaction = Transaction.last
      expect(transaction.full_price).to eq(product.price)
      expect(transaction.net_price).to eq(product.price - (product.price * payment_method_option.discount / 100))
      expect(transaction.token).to be_present
      expect(transaction).to be_pending
    end

    it 'generate a card transaction' do
      post '/api/v1/transactions', params: {
        business_token: business_register.token,
        payment_option_token: card_payment_option.token,
        product_token: product.token,
        customer_token: customer.token,
        payment_details: {
          card_number: '123456789102',
          card_name: 'Jão da Silva',
          card_cvv: '132'
        }
      }

      expect(response).to have_http_status(201)
      transaction = Transaction.last
      expect(transaction.full_price).to eq(product.price)
      expect(transaction.net_price).to eq(product.price - (product.price * card_payment_option.discount / 100))
      expect(transaction.token).to be_present
      expect(transaction).to be_pending
      expect(transaction.payment_details.card_number).to eq('123456789102') 
      expect(transaction.payment_details.card_name).to eq('Jão da Silva') 
      expect(transaction.payment_details.card_cvv).to eq('132') 
    end

    xit 'generate bank slip transaction' do
    end

    xit 'validate tokens params' do
      
    end

    xit 'validates transaction params' do
      
    end

    xit 'validates bank paramns' do
      
    end

    xit 'validates card params' do
      
    end

    xit 'validates payment option enabled' do
      
    end
  end
end