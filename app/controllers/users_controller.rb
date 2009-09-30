class UsersController < ApplicationController
  before_filter :check_for_cancel
  
  access_control do
    allow logged_in
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      msg = "User: #{@user.username} successfully added"
      if User.count == 1
        if @user.has_role! :admin
          msg << " and set as administrator as #{@user.username} is the first user"
        else
          msg << " but could not be set as administrator (but should be as this is the first user)"
        end
      end
      flash[:notice] = msg
      redirect_to user_path
    else
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
    #render :layout=>'user'
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated profile."
      redirect_to user_path
    else
      render :action => 'edit'
    end
  end

  def new
    @user = User.new
  end
  
  def show
    @user = current_user
    #render :layout=>'user'
  end
  
  private
    def check_for_cancel
      redirect_to root_url if params[:cancel]
    end
end
