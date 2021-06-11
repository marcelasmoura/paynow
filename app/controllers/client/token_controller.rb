class Client::TokenController < ApplicationController
  def index
    
  end

  def new_token
    business = BusinessRegister.find(params[:business_register_id])
    business.generate_token!
    business.save!
    redirect_to client_token_index_path
  end
end
