class PaymentMethod < ApplicationRecord
  has_one_attached :payment_icon

  validates :name, presence: true

  enum payment_type: [:pix, :bank_slip, :card]
end
