class TrainingController < CvBaseController
  
  before_filter :check_for_cancel
  
  def index
    @training = @cv.training.find(:all, :order=>"year DESC")
  end
  
  def show
    @training = @cv.training.find(params[:id])
  end
  
  def new
    @training = @cv.training.new
    @form_path = cv_training_path(@cv, @training)
    @institution_fields = :institution_attributes
  end
  
  def create
    @training = @cv.training.new(params[:training])
    if @training.save
      flash[:notice] = "Successfully created training."
      redirect_to cv_training_path(@cv)
    else
      flash[:error] = "Some error here"
      render :action => 'new'
    end
  end
  
  def edit
    @training = @cv.training.find(params[:id])
    @form_path = cv_training_instance_path(@cv, @training)
    @institution_fields = :institution
  end
  
  def update
    @training = @cv.training.find(params[:id])
    if @training.update_attributes(params[:training])
      flash[:notice] = "Successfully updated training entry."
      redirect_to cv_training_path(@cv)
    else
      render :action => 'edit'
    end
  end
  
  def delete
    @training = @cv.training.find(params[:id])
  end
  
  def destroy
    @training = @cv.training.find(params[:id])
    @training.destroy
    flash[:notice] = "Successfully removed."
    redirect_to cv_training_path(@cv)
  end
  
  private
    def load_cv
      @cv = Cv.find(params[:cv_instance_id])
    end
    
    def check_for_cancel
      redirect_to cv_training_path(@cv) if params[:cancel]
    end

end
