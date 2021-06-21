class AddDueDateToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :due_date, :datetime
  end
end
