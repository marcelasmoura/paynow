class Api::V1::CustomersController < ApplicationController
	skip_before_action :authenticate_user!

	def create
		business = BusinessRegister.where(token: params[:business_token]).last
		@customer = Customer.new(customer_params)
		if @customer.save
			RegisterCustomer.create!(business_register_id: business.id, customer_id: @customer.id)
			render json: {full_name: @customer.full_name, cpf: @customer.cpf}, status: :created
		else
		end
	end

	private

	def customer_params
		params.require(:customer).permit(:full_name, :cpf)
	end

end