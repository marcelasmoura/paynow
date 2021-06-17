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

    let!(:business_register2) do
      BusinessRegister.create!(corporate_name: 'GloboPlay',
                               billing_address: 'Rua da Estrela, 75',
                               state: 'Rio de Janeiro',
                               zip_code: '12129589',
                               billing_email: 'globoplay@globoplay.com',
                               cnpj: '123456789000125',
                               domain: 'globoplay.com.br'
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

    it 'not duplicate customers' do
      post '/api/v1/customers', params: {
        customer: {
          full_name: 'João da Silva',
          cpf: '12345678912'
        },
        business_token: business_register.token
      }

      expect(response).to have_http_status(201)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['full_name']).to eq('João da Silva')
      expect(parsed_body['cpf']).to eq('12345678912')

      post '/api/v1/customers', params: {
        customer: {
          full_name: 'João da Silva',
          cpf: '12345678912'
        },
        business_token: business_register.token
      }

      expect(response).to have_http_status(200)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['full_name']).to eq('João da Silva')
      expect(parsed_body['cpf']).to eq('12345678912')

      expect(Customer.count).to eq 1
      expect(RegisterCustomer.count).to eq 1
    end

    it 'one customer for many business' do
      post '/api/v1/customers', params: {
        customer: {
          full_name: 'João da Silva',
          cpf: '12345678912'
        },
        business_token: business_register.token
      }

      expect(response).to have_http_status(201)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['full_name']).to eq('João da Silva')
      expect(parsed_body['cpf']).to eq('12345678912')

      post '/api/v1/customers', params: {
        customer: {
          full_name: 'João da Silva',
          cpf: '12345678912'
        },
        business_token: business_register2.token
      }

      expect(response).to have_http_status(201)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['full_name']).to eq('João da Silva')
      expect(parsed_body['cpf']).to eq('12345678912')

      expect(Customer.count).to eq 1
      expect(RegisterCustomer.count).to eq 2
    end

    it 'do not create customer if business token is invalid' do
      post '/api/v1/customers', params: {
        customer: {
          full_name: 'João da Silva',
          cpf: '12345678912'
        },
        business_token: '54652646258634'
      }

      expect(response).to have_http_status(401)
      expect(Customer.count).to eq 0
      expect(RegisterCustomer.count).to eq 0
    end

    it 'validate require atributtes' do
      post '/api/v1/customers', params: {
        customer: {
          full_name: '',
          cpf: ''
        },
        business_token: business_register2.token
      }

      expect(response).to have_http_status(422)
      parsed_body = JSON.parse(response.body)
      expect(Customer.count).to eq 0
      expect(RegisterCustomer.count).to eq 0
      expect(parsed_body['errors']['full_name']).to include('não pode ficar em branco')
      expect(parsed_body['errors']['cpf']).to include('não pode ficar em branco')
    end

    it 'customers params can not be empty' do
      post '/api/v1/customers', params: {
        customer: {
          
        },
        business_token: business_register2.token
      }

      expect(response).to have_http_status(400)
    end
  end
end