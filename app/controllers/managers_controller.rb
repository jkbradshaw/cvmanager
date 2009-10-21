class ManagersController < ApplicationController
  
  layout 'users'
  
  before_filter :set_user
  
  access_control do
    allow logged_in
  end

  def index
    @cv = @user.cv
    @cv_managers = @cv.managers
  end
  
  def new
  end
  
  def create
    redirect_to cv_managers_url and return if params[:cancel]
    if params[:managers]
      params[:managers].each do |userid,value|
        User.find(userid).has_role!(:manager,@user.cv) if User.exists?(userid)
      end
    end
    redirect_to user_managers_url
  end
  
  def search
    @matches = User.search(params[:search]).all
    @exclusions = [@user]
    @exclusions << @user.cv.managers
    @matches = @matches - @exclusions
  end
  
  def delete
    @manager = User.find(params[:id])
    unless @manager and @manager.has_role?(:manager, @user.cv)
      flash[:error] = "#{@manager.name} is not a manager of your CV"
      redirect_to cv_managers_url
    end
  end
  
  def destroy
    redirect_to cv_managers_url and return if params[:cancel]
    @manager = User.find(params[:id])
    unless @manager and @manager.has_role?(:manager, @user.cv)
      flash[:error] = "#{@manager.name} is not a manager of your CV"
    else
      @manager.has_no_role!(:manager, @user.cv)
      flash[:notice] = "Successfully removed #{@manager.name} as a manager of your CV"
    end
    redirect_to cv_managers_url
  end
  
  private
    def set_user
      @user = current_user
    end
  
end