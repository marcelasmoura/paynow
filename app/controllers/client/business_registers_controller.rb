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
		@business = business_register
	end

	def edit
		@business = business_register
	end

  def update
    @business = business_register
    if @business.update(business_params)
      redirect_to client_business_register_path(@business)
    else
      render :edit
    end
  end

	private

	def business_register
		if current_user.super_admin?
			BusinessRegister.find(params[:id])
		else
			current_user.business_register
		end
		
	end

	def business_params
		params.require(:business_register).permit(:corporate_name, :billing_address, :state, :zip_code, :billing_email, :cnpj, :domain)
	end
end