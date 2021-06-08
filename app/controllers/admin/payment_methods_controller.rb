class Admin::PaymentMethodsController < ApplicationController
	def index
		@payment_methods = PaymentMethod.all
	end

	def new
		@payment_method = PaymentMethod.new		
	end

  def create
    @payment_method = PaymentMethod.new(payment_method_params)
    if @payment_method.save
        redirect_to admin_payment_methods_path
    else
      render :new
    end
  end

  private

  def payment_method_params
    params.require(:payment_method).permit(:name, :payment_icon, :charge_fee, :minimum_fee, :available)
  end
end