class AddTypeToPaymentMethod < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_methods, :payment_type, :integer
  end
end
