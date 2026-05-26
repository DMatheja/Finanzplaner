class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Welcome, #{user.name}!"
    else
      redirect_to login_path, alert: 'Invalid email or password'
    end
  end
  
  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: 'Logged out successfully'
  end
end
