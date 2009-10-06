class GrantsController < CvBaseController
  
  before_filter :check_for_cancel, :only=>[:create, :edit, :update, :destroy]
  
  def index
    @grants = Grant.cv_id_is(@cv.id).descend_by_start_date.all
  end
  
  def show
    @grant = @cv.grants.find(params[:id])
  end
  
  def new
    @grant = @cv.grants.new
  end
  
  def edit
    @grant = @cv.grants.find(params[:id])
  end
  
  def create
    @grant = @cv.grants.new(params[:grant])
    if @grant.save
      flash[:notice] = "Successfully created"
      redirect_to cv_grants_url(@cv)
    else
      flash[:error] = "Problems creating"
      render :action => 'new'
    end
  end
  
  def update
    @grant = @cv.grants.find(params[:id])
    if @grant.update_attributes(params[:grant])
      flash[:notice] = "Successfully updated"
      redirect_to cv_grants_url(@cv)
    else
      flash[:error] = "Problems updating"
      render :action => 'edit'
    end
  end
  
  def delete 
    @grant = @cv.grants.find(params[:id])
  end
  
  def destroy
    @grant = @cv.grants.find(params[:id])
    if @grant.destroy
      flash[:notice] = "Successfully removed from CV"
    else
      flash[:error] = "Problems removing from CV"
    end
    redirect_to cv_grants_url(@cv)
  end
  
  private
    def check_for_cancel
      redirect_to cv_grants_url(@cv) if params[:cancel]
    end
    
end