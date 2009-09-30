class Admin::FacultyController < Admin::AdminController

  def index
    @f = Faculty.find(:all)
    @faculty_members = @f.sort {|a,b| a.last_name.downcase <=> b.last_name.downcase}
  end
  
  def show
    @faculty = Faculty.find(params[:id])
  end
  
  #new and create map to admin/user/faculty
  def new
    @user = User.find(params[:user_id])
    @faculty = @user.build_faculty
    @sections = Section.find(:all, :order => "name").map {|u| [u.name, u.id] }
    @sections = @sections.sort {|a,b| a[0].downcase <=> b[0].downcase}
  end
  
  def create
    redirect_to admin_users_url if params[:cancel]
    @user = User.find(params[:user_id])
    @faculty = @user.build_faculty(params[:faculty])
    if @faculty.save
      flash[:notice] = "Successfully added #{@user.name} to the faculty."
      redirect_to admin_users_url
    else
      flash[:error] = 'Sorry, there was an error adding to the database'
      render :action => 'new'
    end
  end
  
  def edit
    @faculty = Faculty.find(params[:id])
    @sections = Section.find(:all).map {|u| [u.name, u.id] }
    @sections = @sections.sort {|a,b| a[0].downcase <=> b[0].downcase}   
  end
  
  def update
    redirect_to admin_faculty_url and return if params[:cancel]
    @faculty = Faculty.find(params[:id])
    if @faculty.update_attributes(params[:faculty])
      flash[:notice] = "Successfully updated faculty."
      redirect_to admin_faculty_url
    else
      render :action => 'edit'
    end
  end
  
  def delete
    @faculty = Faculty.find(params[:id])
  end
  
  def destroy
    redirect_to admin_faculty_url and return if params[:cancel]
    @faculty = Faculty.find(params[:id])
    @faculty.destroy
    flash[:notice] = "Successfully removed #{@faculty.user.name}."
    redirect_to admin_faculty_url
  end
  
end
