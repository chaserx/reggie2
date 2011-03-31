class UsersController < ApplicationController
  if User.count > 0
    before_filter :logged_in?
  else
    raise "User count is zero. Check User table. Perhaps, run rake db:seed"
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to registrations_url, :notice => "Signed up!"
    else
      render "new"
    end
  end
  
end
