class Admin::CmeCategoriesController < Admin::AdminController
  
  before_filter :check_for_cancel

  
  def index
    @categories = CmeCategory.all
  end

  def new
    @category = CmeCategory.new
  end
  
  def create
    @category = CmeCategory.new(params[:cme_category])
    
    if @category.save
      flash[:notice] = 'Category was successfully created.'
      redirect_to admin_cme_categories_path
    else
      render :action=>'new'
    end
  end
  
  def edit
    @category = CmeCategory.find(params[:id])
  end
  
  def update
    @category = CmeCategory.find(params[:id])
    if @category.update_attributes(params[:cme_category])
      flash[:notice] = "Successfully updated"
      redirect_to admin_cme_categories_path
    else
      flash[:error] = "Problem updating"
      render 'edit'
    end
  end
  
  def delete
    @category = CmeCategory.find(params[:id])
  end
  
  def destroy
    @category = CmeCategory.find(params[:id])
    if @category.destroy
      flash[:notice] = "Successfully removed"
    else
      flash[:error] = "Problem removing"
    end
    redirect_to admin_cme_categories_path
  end
  
  private
    def check_for_cancel
      redirect_to admin_cme_categories_path if params[:cancel]
    end

end