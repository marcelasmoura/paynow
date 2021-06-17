class CreateCardPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :card_payments do |t|
      t.string :card_number
      t.string :card_name
      t.string :card_cvv

      t.timestamps
    end
  end
end
