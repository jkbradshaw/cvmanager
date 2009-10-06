class PatentsController < CvBaseController
  before_filter :check_for_cancel
  
  def index
    @patents = @cv.patents.find(:all, :order=>'year DESC')
  end
  
  def show
    @patent = @cv.patents.find(params[:id])
  end
  
  def new
    @patent = @cv.patents.new
  end
  
  def edit
    @patent = @cv.patents.find(params[:id])
  end
  
  def create
    @patent = @cv.patents.new(params[:patent])
    if @patent.save
      flash[:notice] = "Successfully created"
      redirect_to cv_patents_url(@cv)
    else
      flash[:error] = "Problems creating"
      render :action=>'new'
    end
  end
  
  def update
    @patent = @cv.patents.find(params[:id])
    if @patent.update_attributes(params[:patent])
      flash[:notice] = "Successfully updated"
      redirect_to cv_patents_url(@cv)
    else
      flash[:error] = "Problems updating"
      render :action => 'edit'
    end
  end
  
  def delete 
    @patent = @cv.patents.find(params[:id])
  end
  
  def destroy
    @patent = @cv.patents.find(params[:id])
    if @patent.destroy
      flash[:notice] = "Successfully removed from CV"
    else
      flash[:error] = "Problems removing from CV"
    end
    redirect_to cv_patents_url(@cv)
  end
  
  private
    def check_for_cancel
      redirect_to cv_patents_url(@cv) if params[:cancel]
    end
    
end