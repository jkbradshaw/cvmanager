class PermissionsController < ApplicationController
  
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
    redirect_to user_permissions_url and return if params[:cancel]
    if params[:managers]
      params[:managers].each do |userid,value|
        User.find(userid).has_role!(:manager,@user.cv) if User.exists?(userid)
      end
    end
    redirect_to user_permissions_url
  end
  
  def search
    @matches = User.search(params[:search]).all
    @exclusions = [@user]
    @exclusions << @user.cv.managers
    @matches = @matches - @exclusions
  end
  
  private
    def set_user
      @user = current_user
    end
  
end