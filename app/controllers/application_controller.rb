class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  def login_required
    flash[:msg] = "You need to be logged in!"
    redirect_to root_path if current_user.nil?
  end

  def guest_only
    redirect_to channel_path if logged_in?
  end
end
