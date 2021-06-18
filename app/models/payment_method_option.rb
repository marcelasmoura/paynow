class PaymentMethodOption < ApplicationRecord
  belongs_to :payment_method

  validates :token, uniqueness: true

  def bank_febraban_cod_and_name
    "#{cod_febraban} - #{Febraban::ASSOCIATES[cod_febraban]}"
  end
end
