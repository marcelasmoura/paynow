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

    xit 'generate a card transaction' do
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
  end
end