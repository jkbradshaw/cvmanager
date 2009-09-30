class EducationController < CvBaseController

  before_filter :check_for_cancel
  
  def index
    @education = @cv.education.find(:all, :order=>"year DESC")
  end
  
  def show
    @education = @cv.education.find(params[:id])
  end
  
  def new
    @education = @cv.education.new
    @form_path = cv_education_path(@cv, @education)
    @institution_fields = :institution_attributes
  end
  
  def create
    @education = @cv.education.new(params[:education])
    if @education.save
      flash[:notice] = "Successfully created education."
      redirect_to cv_education_path(@cv)
    else
      flash[:error] = "Some error here"
      redirect_to new_cv_education_instance_path(@cv)
    end
  end
  
  def edit
    @education = @cv.education.find(params[:id])
    @form_path = cv_education_instance_path(@cv, @education)
    @institution_fields = :institution
  end
  
  def update
    @education = @cv.education.find(params[:id])
    if @education.update_attributes(params[:education])
      flash[:notice] = "Successfully updated education entry."
      redirect_to cv_education_path(@cv)
    else
      redirect_to edit_cv_education_instance_path(@cv, @education)
    end
  end
  
  def delete
    @education = @cv.education.find(params[:id])
  end
  
  def destroy
    @education = @cv.education.find(params[:id])
    if @education.destroy
      flash[:notice] = "Successfully removed."
    else
      flash[:error] = "Problem removing"
    end
    redirect_to cv_education_path(@cv)
  end
  
  private   
    def check_for_cancel
      redirect_to cv_education_path(@cv) if params[:cancel]
    end
    
end
