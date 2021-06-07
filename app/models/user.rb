class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: [:super_admin, :client_admin, :client]

  before_create :set_admin_role!

  private

  def set_admin_role!
    if email.include? '@paynow.com.br'
      self.role = :super_admin
    else
      if User.where('email like ?', '%@codeplay.com.br').any?
        self.role = :client
      else
        self.role = :client_admin
      end
    end
  end
end
