class TransactionHistory < ApplicationRecord
  belongs_to :transaction_origin, class_name: 'Transaction', foreign_key: :transaction_id

  enum transaction_status: [:pending, :approved, :rejected]

  def payment_status_cod_and_name
    "#{payment_code} - #{PaymentStatusCode::CODES[payment_code]}"
  end
end
