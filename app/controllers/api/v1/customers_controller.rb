class Api::V1::CustomersController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    business = BusinessRegister.where(token: params[:business_token]).last
    if business.nil?
      render json: {}, status: :unauthorized
      return
    end
    @customer = Customer.new(customer_params)

    if Customer.where(cpf: @customer.cpf).exists? 
      customer = Customer.where(cpf: @customer.cpf).last
      if RegisterCustomer.where(customer_id: customer.id, business_register_id: business.id).exists?
        render json: {full_name: customer.full_name, cpf: customer.cpf}, status: :ok
      else
        RegisterCustomer.create!(business_register_id: business.id, customer_id: customer.id)
        render json: {full_name: @customer.full_name, cpf: @customer.cpf}, status: :created
      end
    elsif @customer.save
      RegisterCustomer.create!(business_register_id: business.id, customer_id: @customer.id)
      render json: {full_name: @customer.full_name, cpf: @customer.cpf}, status: :created
    else
      render json: {errors: @customer.errors}, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing
    render json: {}, status: :bad_request
  end

  private

  def customer_params
    params.require(:customer).permit(:full_name, :cpf)
  end

end