class EmploymentController < CvBaseController
  before_filter :load_employment, :only => [:edit, :update, :destroy, :delete]
  before_filter :check_for_cancel
  
  def index
    @employment = @cv.employment
  end
  
  def new
    @employment = @cv.employment.new
    @institution_fields = :institution_attributes
  end
  
  def create
    @employment = @cv.employment.new(params[:employment])
    if @employment.save
      flash[:notice] = "Successfully created"
      redirect_to cv_employment_path(@cv)
    else
      flash[:error] = "Problems adding"
      render 'new'
    end
  end
  
  def edit
    @institution_fields = :institution
  end
  
  def update
    if @employment.update_attributes(params[:employment])
      flash[:notice] = "Successfully updated"
      redirect_to cv_employment_path(@cv)
    else
      flash[:error] = "Problems updating"
      render 'edit'
    end
  end
  
  def delete
  end
  
  def destroy
    if @employment.destroy
      flash[:notice] = "Successfully removed"
      redirect_to cv_employment_path(@cv)
    else
      flash[:error] = "Problems removing"
      redirect_to cv_employment_path(@cv)
    end
  end
  
  private
    def load_employment
      @employment = @cv.employment.find(params[:id])
    end
    
    def check_for_cancel
      redirect_to cv_employment_path(@cv) if params[:cancel]
    end
end
       