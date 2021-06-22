class Admin::TransactionsController < ApplicationController
  def index
    @transactions = Transaction.where(status: :pending)
  end

  def show
    @transaction = Transaction.find(params[:id])
    @histories = TransactionHistory.where(transaction_id: @transaction.id)
  end

  def edit
    @transaction = Transaction.find(params[:id])
  end

  def update
    @transaction = Transaction.find(params[:id])
    if transaction_rejected?
      TransactionHistory.create!(
        transaction_history_params
          .merge(transaction_status: :rejected, transaction_id: @transaction.id)
      )
      redirect_to admin_transaction_path(@transaction)
    else
      @transaction.update(status: :approved)
      TransactionHistory.create!(
        transaction_history_params
          .merge(transaction_status: :approved, transaction_id: @transaction.id)
      )
      redirect_to admin_transactions_path
    end
  end

  private

  def status_params
    params.require(:transaction).permit(:status)
  end

  def transaction_history_params
    params.require(:transaction_history).permit(:payment_date, :payment_code)
  end

  def transaction_rejected?
    status_params[:status].to_i == 2
  end
end