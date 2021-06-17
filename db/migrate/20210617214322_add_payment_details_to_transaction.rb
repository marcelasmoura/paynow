class AddPaymentDetailsToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_reference :transactions, :payment_details, polymorphic: true, index: {name: 'index_polymorphic_payment_details'}
  end
end

