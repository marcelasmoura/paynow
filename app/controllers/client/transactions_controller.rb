class Client::TransactionsController < ApplicationController
  def index
    @transactions = Transaction.where(business_register_id: current_user.business_register_id)
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

end