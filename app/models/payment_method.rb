class PaymentMethod < ApplicationRecord
	has_one_attached :payment_icon
end
