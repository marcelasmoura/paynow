class Client::BusinessRegistersController < ApplicationController
	def new
		@business = BusinessRegister.new
	end

	def create
		@business = BusinessRegister.new(business_params)
		if @business.save
      current_user.update(business_register_id: @business.id)
      redirect_to client_home_index_path
		else
			render :new
		end
	end

	def show
		@business = current_user.business_register
	end

	def edit
		@business = current_user.business_register
	end

  def update
    @business = current_user.business_register
    if @business.update(business_params)
      redirect_to client_business_register_path(current_user.business_register)
      #render :show
    else
      render :edit
    end
  end

	private

	def business_params
		params.require(:business_register).permit(:corporate_name, :billing_address, :state, :zip_code, :billing_email, :cnpj, :domain)
	end
end