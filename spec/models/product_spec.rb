require 'rails_helper'

RSpec.describe Product, type: :model do
  it 'Generate a token for product when it was created' do
    payment_method = PaymentMethod.create!(name: 'Pix',
                          charge_fee: 0.2,
                          minimum_fee: 2,
                          available: true,
                          payment_icon: {
                            io: File.open(Rails.root.join('spec', 'fixtures', 'banco.jpeg')),
                            filename: 'banco.jpeg'
                          })

    payment_method_option = PaymentMethodOption.create!(payment_method: payment_method, 
                                cod_febraban: '077 - Banco Inter S.A.',
                                discount: 2,
                                token: 'SDPNtC2BbkCbNxsPEirO',
                                active: true
                                )

    product = Product.create(name: 'Curso A',
                            price: 50.00,
                            payment_method_option_id: payment_method_option.id)

    expect(product.token).to be_present
    expect(product.token.size).to eq 20
  end
end
