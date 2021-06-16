class RegisterCustomer < ApplicationRecord
  belongs_to :customer
  belongs_to :business_register
end
