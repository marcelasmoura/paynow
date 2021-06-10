class Client::BusinessRegistersController < ApplicationController
	def new
		@business = BusinessRegister.new
	end

	def create
		@business = BusinessRegister.new(business_params)
		if @business.save
      redirect_to client_home_index_path
		else
			render :new
		end
	end

	def show
		@business = current_user.business.find(params[:id])
	end

	private

	def business_params
		params.require(:business_register).permit(:corporate_name, :billing_address, :state, :zip_code, :billing_email, :cnpj, :domain)
	end
end