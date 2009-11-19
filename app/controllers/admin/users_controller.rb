class Admin::UsersController < Admin::AdminController
  before_filter :check_for_cancel
  
  def index
    @users = User.find(:all, :order=>'last_name ASC')
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created"
      redirect_to admin_users_path
    else
      flash[:error] = "Problems creating user"
      redirect_to new_admin_user_path
    end
  end
  
  def delete
    @user = User.find(params[:id])
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "Successfully removed"
      redirect_to admin_users_path
    else
      flash[:error] = "Problems removing"
      redirect_to admin_users_path
    end
  end
  
  def permissions
    @site_permissions = User.site_permissions
    @user = User.find(params[:id])
    @user_permissions = @user.role_objects.collect {|x| x.name unless x.authorizable_type.nil?}
    @user_permissions.reject! {|x| x.nil?}
  end
  
  def update_permissions
    @user = User.find(params[:id])
    @user_permissions = params['roles']
    @user_permissions.reject! {|x| x == 'admin'} if current_user == @user
    if @user.update_permissions(@user_permissions)
      flash[:notice] = "Updated permissions"
    else
      flash[:error] = "Problems updating permissions"
    end
    redirect_to admin_users_url
  end
  
  private
    def check_for_cancel
      redirect_to admin_users_path if params[:cancel]
    end

end