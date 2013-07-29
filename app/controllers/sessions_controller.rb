class SessionsController < ApplicationController
  before_filter :current_session, only: [:create, :destroy]
  skip_before_filter :sign_in, only: [:new, :create]

  def new
  end

  def create
    ldap_auth = LdapAuth.new(params[:user][:username], params[:user][:password])

    if (ldap_user = ldap_auth.authenticate?)
      session[:ldap_username] = ldap_user.username
      @sess.update_attributes(username: ldap_user.username)
      redirect_to channels_path, notice: "User logged in successfully"
    else
      render :new, alert: "Login failed"
    end
  end

  def destroy
    session[:ldap_username] = nil
    @sess.destroy
    redirect_to new_session_path, notice: "Logged out successfully"
  end

  private
  def current_session
    @sess = Session.find_by_session_id(session.id)
  end
end
