class Admin::ClientUsersController < ApplicationController
  def index
    @clients = BusinessRegister.all
  end

  def show
    @client = BusinessRegister.find(params[:id])
  end

  def edit
    @client = BusinessRegister.find(params[:id])
  end

  def update
    @client = BusinessRegister.find(params[:id])
  end
end