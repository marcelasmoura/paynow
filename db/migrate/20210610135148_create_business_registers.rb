class CreateBusinessRegisters < ActiveRecord::Migration[6.0]
  def change
    create_table :business_registers do |t|
      t.string :corporate_name
      t.string :billing_address
      t.string :state
      t.string :zip_code
      t.string :billing_email
      t.string :cnpj
      t.timestamps
    end
  end
end
