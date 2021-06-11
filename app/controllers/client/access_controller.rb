class Client::AccessController < ApplicationController
  def index
    @users = User.pending.by_domain(current_user.business_register.domain)
  end

  def allow
    u = User.find(params[:user_id])
    u.update(pending: false)
    redirect_to client_access_index_path
  end

  def deny
    u = User.find(params[:user_id])
    u.destroy
    redirect_to client_access_index_path
  end
end