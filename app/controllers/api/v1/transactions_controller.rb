class Api::V1::TransactionsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    business = BusinessRegister.where(token: token_params[:business_token]).last
    payment = PaymentMethodOption.where(token: token_params[:payment_option_token]).last
    product = Product.where(token: token_params[:product_token]).last
    customer = Customer.where(token: token_params[:customer_token]).last

    if business.nil? || payment.nil? || product.nil? || customer.nil?
      render json: {}, status: :bad_request
      return
    end

    if !payment.active?
      render json: {errors: {payment_option_token: 'Método de pagamento inativo'}}, status: :unprocessable_entity
      return
    end

    discount = payment.discount
    if discount.nil? || discount.zero?
      discount = 1
    end

    full_price = product.price
    net_price = full_price - (full_price * discount / 100)

    payment_details = nil
    if payment.payment_method.card?
      payment_details = CardPayment.new(card_params)
    elsif payment.payment_method.bank_slip?
      payment_details = BankSlipPayment.new(bank_slip_params)
    end

    @transaction = Transaction.new(business_register_id: business.id,
                                   payment_method_option_id: payment.id,
                                   product_id: product.id,
                                   customer_id: customer.id,
                                   full_price: full_price,
                                   discount: discount,
                                   net_price: net_price,
                                   status: :pending)

    if payment_details
      if !payment_details.save
        render json: {errors: {payment_details: payment_details.errors}}, status: :unprocessable_entity
        return
      end
      @transaction.payment_details = payment_details
    end

    if @transaction.save
      render json: {token: @transaction.token}, status: :created
    else
      render json: {errors: @transaction.errors}, status: :unprocessable_entity
    end

  rescue ActionController::ParameterMissing
    render json: {}, status: :bad_request
  end

  private

  def card_params
    params.require(:payment_details).permit(:card_name, :card_number, :card_cvv)
  end

  def bank_slip_params
    params.require(:payment_details).permit(:full_address)
  end

  def token_params
    params.require([:business_token, :payment_option_token, :product_token, :customer_token])
    params
  end
end