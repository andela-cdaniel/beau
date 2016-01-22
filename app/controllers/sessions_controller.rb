class SessionsController < ApplicationController
  before_action :guest_only, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by_username(params[:session][:username].downcase)

    if user && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_to channel_path
    else
      flash.now[:msg] = "Trying to be smart eh?, that user doesn't exist"
      render :new
    end
  end

  def destroy
    log_out
    flash[:msg] = "You are now signed out!"
    redirect_to root_path
  end
end
