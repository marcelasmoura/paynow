class AddDomainToBusinessRegister < ActiveRecord::Migration[6.0]
  def change
    add_column :business_registers, :domain, :string
  end
end
