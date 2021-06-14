class Admin::TokenController < ApplicationController
  def new_token
    client_token = BusinessRegister.find(params[:business_register_id])
    client_token.generate_token!
    client_token.save!
    redirect_to admin_client_user_path(client_token)
  end
end