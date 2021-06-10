require 'rails_helper'

describe BusinessRegister, type: :model do
  it 'Generate a token for business when it was created' do
    business = BusinessRegister.create!(corporate_name: 'CodePlay',
                                        billing_address: 'Rua A, 20',
                                        state: 'São Paulo',
                                        zip_code: '25254282',
                                        billing_email: 'codeplay@codeplay.com.br',
                                        cnpj: '123456000156',
                                        domain: 'codeplay.com.br'
                                       )
    expect(business.token).to be_present
    expect(business.token.size).to eq 20
  end
end
