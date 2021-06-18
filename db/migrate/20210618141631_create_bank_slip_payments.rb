class CreateBankSlipPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :bank_slip_payments do |t|
      t.string :full_address

      t.timestamps
    end
  end
end
