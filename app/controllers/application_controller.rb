class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def current_user
    @user = session[:user]
  end
  
  def login_check
    unless @user
      redirect_to :controller => "auth", :action => "index"
    end
  end
end
