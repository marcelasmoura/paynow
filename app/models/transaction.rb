class Transaction < ApplicationRecord
  belongs_to :business_register
  belongs_to :payment_method_option
  belongs_to :product
  belongs_to :customer
  belongs_to :payment_details, polymorphic: true, optional: true

  has_many :transaction_histories

  validates :full_price, presence: true
  validates :token, uniqueness: true

  before_create :generate_token!
  before_create :set_default_due_date

  enum status: [:pending, :approved, :rejected]

  def status=(value)
    value =  Integer(value) rescue value
    super value
  end

  private

  def generate_token!
    self.token = SecureRandom.alphanumeric(20)
  end

  def set_default_due_date
    self.due_date = 5.days.from_now.end_of_day
  end
end
