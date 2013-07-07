class AuthController < ApplicationController
  def index
  end

  def auth
  end

  def logout
    session.clear
    redirect_to :action => "index"
  end

  def callback
    @user = User.build(request.env['omniauth.auth'])
    User.save(@user)
    session[:user] = @user
    redirect_to :controller => "collections" , :action => "index"
  end
end
