class AddTokenToBusinessRegister < ActiveRecord::Migration[6.0]
  def change
    add_column :business_registers ,:token, :string
  end
end
