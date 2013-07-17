class SessionsController < ApplicationController
  before_filter :current_session, only: [:create, :destroy]
  skip_before_filter :sign_in, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by_email(params[:user][:email])

    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      @sess.update_attributes(user_id: user.id)
      redirect_to channels_path, notice: "User logged in successfully"
    else
      render :new, alert: "Login failed"
    end
  end

  def destroy
    session[:user_id] = nil
    @sess.destroy
    redirect_to new_session_path, notice: "Logged out successfully"
  end

  private
  def current_session
    @sess = Session.find_by_session_id(session.id)
  end
end
