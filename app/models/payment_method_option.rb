class PaymentMethodOption < ApplicationRecord
  validates :token, uniqueness: true
  
  belongs_to :payment_method

  def bank_febraban_cod_and_name
    "#{cod_febraban} - #{Febraban::ASSOCIATES[cod_febraban]}"
  end
end
