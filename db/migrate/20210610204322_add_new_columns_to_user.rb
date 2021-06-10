class AddNewColumnsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :business_register_id, :integer, references: :business_registers
    add_column :users, :pending, :boolean
  end
end
