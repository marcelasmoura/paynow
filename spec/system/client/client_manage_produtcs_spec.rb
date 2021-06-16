require 'rails_helper'

describe 'Client can' do
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
                                discount: 2,
                                token: 'SDPNtC2BbkCbNxsPEirO',
                                active: true
                                )
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

  let!(:user) do
    User.create!(email: 'admin@codeplay.com.br',
                 password: 'thisisapassword',
                 password_confirmation: 'thisisapassword',
                 business_register_id: business_register.id
                 )
    end

  before do
    sign_in user
  end

  it 'add a new product' do
    visit client_home_index_path
    click_on 'Produtos'
    click_on 'Novo Produto'

    fill_in 'Nome', with: 'Curso A'
    fill_in 'Valor', with: 50.00
    select 'Pix', from: 'Método de Pagamento'
    check 'Ativar'
    click_on 'Salvar'

    expect(page).to have_text('Curso A')
    expect(page).to have_link('Novo Produto')
  end

  it 'see all your registered products' do
    product1 = Product.create!(name: 'Curso A',
                               price: 50.00,
                               payment_method_option_id: payment_method_option.id)
    product2 = Product.create!(name: 'Curso B',
                               price: 50.00,
                               payment_method_option_id: payment_method_option.id)

    visit client_home_index_path
    click_on 'Produtos'

    expect(page).to have_text('Meus Produtos')
    expect(page).to have_link(product1.name)
    expect(page).to have_link(product2.name)
  end

  it 'see a details of one specific product' do
    product = Product.create(name: 'Curso A',
                              price: 50.00,
                              payment_method_option_id: payment_method_option.id)
    visit client_home_index_path
    click_on 'Produtos'
    click_on product.name

    expect(page).to have_text(product.name)
    expect(page).to have_text('R$ 50,00')
    expect(page).to have_text(product.payment_method_option.payment_method.name)
    expect(page).to have_text('Indisponível')
  end

  it 'edit and specific product' do
    product = Product.create(name: 'Curso A',
                              price: 50.00,                
                              payment_method_option_id: payment_method_option.id)
    visit client_home_index_path
    click_on 'Produtos'
    click_on product.name
    click_on 'Editar'

    fill_in 'Nome', with: 'Curso AB'
    fill_in 'Valor', with: 80.00
    select 'Pix', from: 'Método de Pagamento'
    uncheck 'Ativar'
    click_on 'Salvar'

    expect(page).to have_text(product.name)
    expect(page).to have_text('R$ 80,00')
    expect(page).to have_text(product.payment_method_option.payment_method.name)
  end

  it 'delete and specific product' do
    product = Product.create(name: 'Curso A',
                              price: 50.00,
                              payment_method_option_id: payment_method_option.id)
    visit client_home_index_path
    click_on 'Produtos'
    click_on product.name
    
    accept_alert do
      click_on 'Excluir'
    end

    expect(page).to have_text('Meus Produtos')
    expect(page).to_not have_link(product.name)
  end

  it 'see a token of a product' do
    product = Product.create(name: 'Curso A',
                              price: 50.00,
                              payment_method_option_id: payment_method_option.id)
    visit client_home_index_path
    click_on 'Produtos'
    click_on 'Ver Token'

    expect(page).to have_content(product.token)
  end
end