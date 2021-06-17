class RegisterCustomer < ApplicationRecord
  belongs_to :customer
  belongs_to :business_register

  validates :customer_id, uniqueness: {scope: :business_register_id}
end
