class CreatePaymentMethodOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_method_options do |t|
      t.references :payment_method, null: false, foreign_key: true
      t.string :cod_febraban
      t.decimal :discount
      t.string :token
      t.boolean :active

      t.timestamps
    end
  end
end
