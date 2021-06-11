class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :business_register, optional: true

  enum role: [:super_admin, :client_admin, :client]

  before_create :set_admin_role

  scope :pending, -> { where(pending: true) }

  scope :by_domain, ->(domain) { where('email LIKE ?', "%@#{domain}") }

  private

  def set_admin_role
    if email.include? '@paynow.com.br'
      self.role = :super_admin
      self.pending = false
    else
      if User.by_domain('codeplay.com.br').any?
        self.role = :client
        self.pending = true
      else
        self.role = :client_admin
        self.pending = false
      end
    end
  end
end
