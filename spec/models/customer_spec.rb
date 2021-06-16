require 'rails_helper'

describe Customer, type: :model do
  it 'Generate a token for customer when it was created' do
    custumer = Customer.create!(full_name: 'João da Silva',
                                cpf: '12345678912')
    expect(custumer.token).to be_present
    expect(custumer.token.size).to eq 20
  end
end