class CreatePaymentMethods < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_methods do |t|
      t.string :name
      t.decimal :charge_fee
      t.decimal :minimum_fee
      t.boolean :available

      t.timestamps
    end
  end
end
