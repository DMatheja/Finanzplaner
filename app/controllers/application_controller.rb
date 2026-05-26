class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?
  before_action :require_login, except: [:login_page]
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    current_user.present?
  end
  
  def require_login
    unless logged_in?
      redirect_to login_path, alert: 'Please log in first'
    end
  end
  
  def authorize_admin
    redirect_to root_path, alert: 'Access denied' unless current_user&.admin?
  end
  
  def authorize_owner(resource)
    redirect_to root_path, alert: 'Access denied' unless resource.user_id == current_user.id || current_user&.admin?
  end
end
