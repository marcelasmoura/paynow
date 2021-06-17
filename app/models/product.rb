class Product < ApplicationRecord
  belongs_to :payment_method_option

  before_create :generate_token!

  validates :token, uniqueness: true

  private

  def generate_token!
    self.token = SecureRandom.alphanumeric(20)
  end
end
