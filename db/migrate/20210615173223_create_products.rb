class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.string :token
      t.boolean :active
      t.references :payment_method_option, null: false, foreign_key: true

      t.timestamps
    end
  end
end
