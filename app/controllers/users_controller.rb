class UsersController < ApplicationController
  before_action :guest_only

  def welcome
  end

  def create
    @user = User.new
    @user.username = user_params[:username]
    @user.password = user_params[:password]

    if @user.save
      log_in(@user)
      redirect_to channel_path
    else
      flash.now[:msg] = "Incorrect values present in your submission"
      render :register
    end
  end

  def register
    @user = User.new
  end

  def login
    @user = User.new
  end

  private def user_params
    params.require(:user).permit(:username, :password)
  end
end
