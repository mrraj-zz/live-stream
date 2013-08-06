class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :sign_in, :online_users

  helper_method :current_user

  def current_user
    @current_user ||= session[:ldap_username] && session[:ldap_user]
  end

  private
  def sign_in
    redirect_to new_session_path, notice: 'Please login to access this page.' unless current_user
  end

  def online_users
    @online_users = Session.online_users
  end
end
