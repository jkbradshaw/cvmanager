class AwardsController < CvBaseController

  before_filter :check_for_cancel
  
  def index
    @awards = @cv.awards.find(:all, :order=>'year DESC')
  end
  
  def new
    @award = @cv.awards.new
  end
  
  def show
    @award = @cv.awards.find(params[:id])
  end
  
  def create
    @award = @cv.awards.new(params[:award])
    if @award.save
      flash[:notice] = "Successfully added new award"
      redirect_to cv_awards_path(@cv)
    else
      flash[:error] = "Problem creating"
      render :action=>'new'
    end
  end
  
  def edit
    @award = @cv.awards.find(params[:id])
  end
  
  def update
    @award = @cv.awards.find(params[:id])
    if @award.update_attributes(params[:award])
      flash[:notice] = "Successflly updated"
      redirect_to cv_awards_path(@cv)
    else
      flash[:error] = "Problem updating"
      render :action=>'edit'
    end
  end
  
  def delete
    @award = @cv.awards.find(params[:id])
  end
  
  def destroy
    @award = @cv.awards.find(params[:id])
    if @award.destroy
      flash[:notice] = "Successfully removed"
    else
      flash[:error] = "Problem removing"
    end
    redirect_to cv_awards_path(@cv)
  end
  
  private
    def check_for_cancel
      redirect_to cv_awards_path(@cv) if params[:cancel]
    end
end