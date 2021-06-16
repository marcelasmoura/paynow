class CreateRegisterCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :register_customers do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :business_register, null: false, foreign_key: true

      t.timestamps
    end
  end
end
