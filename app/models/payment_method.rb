class PaymentMethod < ApplicationRecord
	has_one_attached :payment_icon

	validates :name, presence: true
end
