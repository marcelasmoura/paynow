class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :full_name
      t.string :cpf
      t.string :token

      t.timestamps
    end
  end
end
