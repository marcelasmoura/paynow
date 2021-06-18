require 'rails_helper'

RSpec.describe Transaction, type: :model do
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

  let!(:pix_payment_method) do
      PaymentMethod.create!(name: 'Pix',
                            charge_fee: 0.2,
                            minimum_fee: 2,
                            available: true,
                            payment_type: :pix,
                            payment_icon: {
                              io: File.open(Rails.root.join('spec', 'fixtures', 'banco.jpeg')),
                              filename: 'banco.jpeg'
                            })
    end

    let!(:pix_payment_option) do
      PaymentMethodOption.create!(payment_method: pix_payment_method, 
                                  cod_febraban: '077 - Banco Inter S.A.',
                                  discount: 10,
                                  token: 'SDPNtC2BbkCbNxsPEirO',
                                  active: true
                                  )
    end

    let!(:product) do
      Product.create!(name: 'Curso A',
                      price: 50.00,
                      payment_method_option_id: pix_payment_option.id)
    end

    let!(:customer) do
      Customer.create!(full_name: 'João da Silva',
                       cpf: '12345678912')
    end

    let!(:register_customer) do
      RegisterCustomer.create!(customer_id: customer.id,
                               business_register_id: business_register.id)
    end
  context 'validations' do
    it 'full_price ' do
      transaction = Transaction.new(business_register_id: business_register.id,
                      payment_method_option_id: pix_payment_option.id,
                      product_id: product.id,
                      customer_id: customer.id,
                      full_price: '',
                      discount: pix_payment_option.discount,
                      status: :pending)

      expect(transaction.save).to be_falsey
      expect(transaction.errors[:full_price]).to include('não pode ficar em branco')
    end
  end
end
