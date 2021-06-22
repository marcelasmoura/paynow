require 'rails_helper'

describe 'Admin/PayNow can' do
  let!(:user) do
      User.create!(email: 'admin@paynow.com.br',
                   password: 'thisisapassword',
                   password_confirmation: 'thisisapassword'
                   )
  end

  before do
    sign_in user
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
                                token: 'SDPNtC2BbkCbNxsPEir1',
                                active: true
                                )
  end
  
  let!(:bank_slip_payment_method) do
    PaymentMethod.create!(name: 'Boleto',
                          charge_fee: 0.2,
                          minimum_fee: 2,
                          available: true,
                          payment_type: :bank_slip,
                          payment_icon: {
                            io: File.open(Rails.root.join('spec', 'fixtures', 'banco.jpeg')),
                            filename: 'banco.jpeg'
                          })
  end
  
  let!(:bank_slip_payment_option) do
    PaymentMethodOption.create!(payment_method: bank_slip_payment_method, 
                                cod_febraban: '077 - Banco Inter S.A.',
                                discount: 10,
                                token: 'SDPNtC2BbkCbNxsPEir2',
                                active: true
                                )
  end

  let!(:product) do
    Product.create!(name: 'Curso A',
                    price: 50.00,
                    payment_method_option_id: pix_payment_option.id)
  end

  let!(:product2) do
    Product.create!(name: 'Curso B',
                    price: 70.00,
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

  let!(:transaction) do
    Transaction.create!(business_register_id: business_register.id,
                                   payment_method_option_id: pix_payment_option.id,
                                   product_id: product.id,
                                   customer_id: customer.id,
                                   full_price: product.price,
                                   discount: pix_payment_option.discount,
                                   net_price: product.price - (product.price * pix_payment_option.discount / 100),
                                   status: :pending)
    end

    let!(:transaction2) do
    Transaction.create!(business_register_id: business_register.id,
                                   payment_method_option_id: card_payment_option.id,
                                   product_id: product2.id,
                                   customer_id: customer.id,
                                   full_price: product2.price,
                                   discount: card_payment_option.discount,
                                   net_price: product2.price - (product2.price * card_payment_option.discount / 100),
                                   status: :pending)
    end

  it 'see a list of transactions' do
    visit admin_home_index_path
    click_on 'Cobranças'

    expect(page).to have_text('Cobranças')
    expect(page).to have_content(transaction.status)
    expect(page).to have_link(product.name)
    expect(page).to have_content(I18n.l transaction.due_date.to_date)
    expect(page).to have_content('Pix')
    expect(page).to have_content(transaction2.status)
    expect(page).to have_link(product2.name)
    expect(page).to have_content(I18n.l transaction2.due_date.to_date)
    expect(page).to have_content('CreditCard')
  end

  it 'see a datails of a transaction' do
    visit admin_home_index_path
    click_on 'Cobranças'
    click_on product2.name

    expect(page).to have_content(product2.name)
    expect(page).to have_content('R$ 70,00')
    expect(page).to have_content('10')
    expect(page).to have_content('R$ 63,00')
    expect(page).to have_content(transaction2.status)
    expect(page).to have_content('CreditCard')
    expect(page).to have_content(I18n.l transaction2.due_date.to_date)
  end

  it 'edit a status of a rejected transaction' do
    visit admin_home_index_path
    click_on 'Cobranças'
    click_on product2.name
    click_on 'Editar Status'

    select 'rejected', from: 'Status'
    fill_in 'Data de Pagamento', with: I18n.l(Date.today)
    select '01 - Pendente de cobrança', from: 'Status de Cobrança'
    click_on 'Salvar'

    expect(page).to have_content(product2.name)
    expect(page).to have_content('R$ 70,00')
    expect(page).to have_content('10')
    expect(page).to have_content('R$ 63,00')
    expect(page).to have_content('pending')
    expect(page).to have_content('CreditCard')
    expect(page).to have_content(I18n.l transaction2.due_date.to_date)
    expect(page).to have_text('Histórico')
    expect(page).to have_text('rejected')
    expect(page).to have_text(I18n.l Date.today)
    expect(page).to have_text('01 - Pendente de cobrança')
  end

  it 'edit a status of a approved transaction' do
    visit admin_home_index_path
    click_on 'Cobranças'
    click_on product2.name
    click_on 'Editar Status'

    select 'approved', from: 'Status'
    fill_in 'Data de Pagamento', with: I18n.l(Date.today)
    click_on 'Salvar'

    expect(page).to_not have_link(product2.name)
  end
end