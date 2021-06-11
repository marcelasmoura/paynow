class BusinessRegister < ApplicationRecord
	validates :corporate_name, :billing_address, :state, :zip_code, :billing_email, :cnpj, :domain, presence: true

	before_create :generate_token!

	def generate_token!
	  self.token = SecureRandom.alphanumeric(20)
	end
end
