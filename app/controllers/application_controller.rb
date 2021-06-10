class ApplicationController < ActionController::Base

  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    if resource.super_admin?
      stored_location_for(resource) || admin_home_index_path
    elsif resource.client?
       stored_location_for(resource) || client_home_index_path
    else
      if BusinessRegister.any?
        stored_location_for(resource) || client_home_index_path
      else
        stored_location_for(resource) || new_client_business_register_path
      end
    end
  end
end
