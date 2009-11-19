class Admin::FacultyController < Admin::AdminController

  before_filter :check_for_cancel, :only=>[:create, :update, :destroy]
  
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
    @faculty = Faculty.find(params[:id])
    if @faculty.update_attributes(params[:faculty])
      respond_to do |format|
        format.html do
          flash[:notice] = "Successfully updated faculty."
          redirect_to admin_faculty_url
        end
        
        format.js {render :json=> {:success=>true, :new_value=>params[:faculty].values.first }.to_json }
        
      end
    else
      respond_to do |format|
        format.html do
          render :action => 'edit'
        end
        
        format.js {render :json=>{:success=>false, :msg=>@faculty.errors.full_messages}.to_json}
        
      end
    end
  end
  
  def delete
    @faculty = Faculty.find(params[:id])
  end
  
  def destroy
    @faculty = Faculty.find(params[:id])
    @faculty.destroy
    flash[:notice] = "Successfully removed #{@faculty.user.name}."
    redirect_to admin_faculty_url
  end
  
  private
    def check_for_cancel
      redirect_to admin_faculty_url and return if params[:cancel]
    end
  
end
