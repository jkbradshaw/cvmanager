class CertificationsController < CvBaseController

  before_filter :check_for_cancel
  
  def index
    @certifications = @cv.certifications.find(:all, :order=>'date_received DESC')
  end
  
  def new
    @certification = @cv.certifications.new
  end
  
  def show
    @certification = @cv.certifications.find(params[:id])
  end
  
  def create
    @certification = @cv.certifications.new(params[:certification])
    if @certification.save
      flash[:notice] = "Successfully added new certification"
      redirect_to cv_certifications_path(@cv)
    else
      flash[:error] = "Problem creating"
      render :action=>'new'
    end
  end
  
  def edit
    @certification = @cv.certifications.find(params[:id])
  end
  
  def update
    @certification = @cv.certifications.find(params[:id])
    if @certification.update_attributes(params[:certification])
      flash[:notice] = "Successflly updated"
      redirect_to cv_certifications_path(@cv)
    else
      flash[:error] = "Problem updating"
      render :action=>'edit'
    end
  end
  
  def delete
    @certification = @cv.certifications.find(params[:id])
  end
  
  def destroy
    @certification = @cv.certifications.find(params[:id])
    if @certification.destroy
      flash[:notice] = "Successfully removed"
    else
      flash[:error] = "Problem removing"
    end
    redirect_to cv_certifications_path(@cv)
  end
  
  private
    def load_cv
      @cv = Cv.find(params[:cv_instance_id])
    end 
    
    def check_for_cancel
      redirect_to cv_certifications_path(@cv) if params[:cancel]
    end
end