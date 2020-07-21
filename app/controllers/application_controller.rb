class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id])
    else
      @current_user = nil
    end
  end

  def logged_in?
    current_user
  end

  def authorize
    redirect_to login_url, alert: "Not authorized" if current_user.nil?
  end
end
