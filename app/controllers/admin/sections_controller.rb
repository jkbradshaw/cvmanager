class Admin::SectionsController < Admin::AdminController
  
  before_filter :check_for_cancel
  
  def index
    @sections = Section.all
  end
  
  def show
    @section = Section.find(params[:id])
  end
    
  def new
    @section = Section.new
  end
  
  def create
    @section = Section.new(params[:section])
    if @section.save
      flash[:notice] = "Successfully created section."
      redirect_to admin_sections_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @section = Section.find(params[:id])
  end
  
  def update
    @section = Section.find(params[:id])
    if @section.update_attributes(params[:section])
      flash[:notice] = "Successfully updated section."
      redirect_to admin_sections_path
    else
      render :action => 'edit'
    end
  end
  
  def delete
    @section = Section.find(params[:id])
  end
  
  def destroy
    @section = Section.find(params[:id])
    @section.destroy
    flash[:notice] = "Successfully destroyed section."
    redirect_to admin_sections_url
  end
  
  private
    def check_for_cancel
      redirect_to admin_sections_path if params[:cancel] 
    end
end
