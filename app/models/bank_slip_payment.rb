class BankSlipPayment < ApplicationRecord
  validates :full_address, presence: true
end
