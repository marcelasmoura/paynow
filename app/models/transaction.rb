class Transaction < ApplicationRecord
  belongs_to :business_register
  belongs_to :payment_method_option
  belongs_to :product
  belongs_to :customer
  belongs_to :payment_details, polymorphic: true, optional: true

  validates :full_price, presence: true
  validates :token, uniqueness: true

  before_create :generate_token!

  enum status: [:pending, :approved, :rejected]

  private

  def generate_token!
    self.token = SecureRandom.alphanumeric(20)
  end
end
