class Customer < ApplicationRecord
  before_create :generate_token!
  has_many :register_customers

  private

  def generate_token!
    self.token = SecureRandom.alphanumeric(20)
  end
end
