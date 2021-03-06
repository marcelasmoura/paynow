class Client::PaymentMethodOptionsController < ApplicationController
  def index
    @payment_options = PaymentMethodOption.all
  end

  def new
    @payment_option = PaymentMethodOption.new
  end

  def create
    @payment_option = PaymentMethodOption.new(payment_params)
    if @payment_option.save
      redirect_to client_payment_method_options_path
    else
      render :new
    end
  end

  def show
    @payment_option = PaymentMethodOption.find(params[:id])
  end

  def edit
    @payment_option = PaymentMethodOption.find(params[:id])
  end

  def update
    @payment_option = PaymentMethodOption.find(params[:id])
    if @payment_option.update!(payment_params)
      render :show
    else
      render :edit
    end
  end

  def destroy
    @payment_option = PaymentMethodOption.find(params[:id])
    @payment_option.destroy
    redirect_to client_payment_method_options_path
  end

  private

  def payment_params
    params.require(:payment_method_option).permit(:payment_method_id, :cod_febraban, :discount, :token, :active)
  end
end
