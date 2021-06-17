class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :business_register, null: false, foreign_key: true
      t.references :payment_method_option, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.decimal :full_price
      t.decimal :discount
      t.decimal :net_price
      t.string :token
      t.integer :status

      t.timestamps
    end
  end
end
