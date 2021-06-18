class CardPayment < ApplicationRecord
  validates :card_name, :card_number, :card_cvv, presence: true
end
