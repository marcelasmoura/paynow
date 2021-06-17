require 'rails_helper'

RSpec.describe RegisterCustomer, type: :model do
  context 'validations' do
    it 'does not duplicate' do
      business = BusinessRegister.create!(corporate_name: 'CodePlay',
                                        billing_address: 'Rua A, 20',
                                        state: 'São Paulo',
                                        zip_code: '25254282',
                                        billing_email: 'codeplay@codeplay.com.br',
                                        cnpj: '123456000156',
                                        domain: 'codeplay.com.br'
                                       )

      customer = Customer.create!(full_name: 'João da Silva',
                                cpf: '12345678912')

      RegisterCustomer.create!(business_register_id: business.id,
                               customer_id: customer.id)

      register = RegisterCustomer.new(business_register_id: business.id,
                                      customer_id: customer.id)  
      expect(register.save).to be_falsey
    end
  end
end
