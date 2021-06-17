class Api::V1::TransactionsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    business = BusinessRegister.where(token: params[:business_token]).last
    payment = PaymentMethodOption.where(token: params[:payment_option_token]).last
    product = Product.where(token: params[:product_token]).last
    customer = Customer.where(token: params[:customer_token]).last

    if business.nil? || payment.nil? || product.nil? || customer.nil?
      render json: {}, status: :bad_request
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
      payment_details = CardPayment.create!(card_params)
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
      @transaction.payment_details = payment_details
    end

    if @transaction.save
      render json: {token: @transaction.token}, status: :created
    else
      render json: {errors: @transaction.errors}, status: :unprocessable_entity
    end
  end

  private

  def card_params
    params.require(:payment_details).permit(:card_name, :card_number, :card_cvv)
  end
end