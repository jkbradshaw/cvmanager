class PresentationsController < CvBaseController
  
  before_filter :check_for_cancel
  before_filter :load_presentation, :only=>[:edit,:update,:delete,:destroy]
  
  def index
    @presentations = Presentation.all
  end
  
  def new
    @presentation = Presentation.new
  end
  
  def create
    @presentation = Presentation.new(params[:presentation])
    if @presentation.save
      flash[:notice] = "Successfully added"
      redirect_to cv_presentations_path(@cv)
    else
      flash[:error] = "Problems creating"
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    @presentation = @cv.presentations.find(params[:id])
    if @presentation.update_attributes(params[:presentation])
      flash[:notice] = "Successfully updated"
      redirect_to cv_presentations_path(@cv)
    else
      flash[:error] = "Problems updating"
      render :action => 'edit'
    end
  end
  
  def delete
  end
  
  def destroy
    @presentation = @cv.presentations.find(params[:id])
    if @presentation.destroy
      flash[:notice] = "Successfully removed"
    else
      flash[:error] = "Problems removing"
    end
    redirect_to cv_presentations_path(@cv)
  end
  
  private
    def check_for_cancel
      redirect_to cv_presentations_path if params[:cancel]
    end
    
    def load_presentation
      @presentation = Presentation.find(params[:id])
    end
end