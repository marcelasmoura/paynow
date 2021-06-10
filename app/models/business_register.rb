class BusinessRegister < ApplicationRecord
	validates :corporate_name, :billing_address, :state, :zip_code, :billing_email, :cnpj, presence: true

	before_create :business_token

	private

	def business_token
	  self.token = SecureRandom.alphanumeric(20)	
	end
end
