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

    it 'should create customers' do
      post '/api/v1/customers', params: {
        customer: {
          full_name: 'João da Silva',
          cpf: '12345678912'
        },
        business_token: business_register.token
      }

      customer = Customer.last
      expect(response).to have_http_status(201)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['full_name']).to eq('João da Silva')
      expect(parsed_body['cpf']).to eq('12345678912')
      expect(customer.token).to be_present
      expect(customer.register_customers.last.business_register_id).to eq business_register.id
    end

    xit 'not duplicate customers' do
      
    end

    xit 'one customer for many business' do
    end
  end
end