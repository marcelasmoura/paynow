class CreateTransactionHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :transaction_histories do |t|
      t.datetime :payment_date
      t.string :payment_code
      t.integer :transaction_status
      t.references :transaction, null: false, foreign_key: true

      t.timestamps
    end
  end
end
