class AddressesController < CvBaseController

  before_filter :find_address, :only => [:show, :edit, :update, :destroy, :delete]
  before_filter :check_for_cancel

  def show
  end

  def new
    @address = @cv.build_address
  end

  def edit
  end

  def create
    @address = @cv.build_address(params[:address])
    if @address.save
      flash[:notice] = 'Successfully created'
      redirect_to cv_address_path(@cv)
    else
      render :action => 'new'
    end
  end

  def update
    if @address.update_attributes(params[:address])
      flash[:notice] = "Successfully updated"
      redirect_to cv_address_path(@cv)
    else
      render :action=>'edit'
    end
  end
  

  def delete
  end
  
  def destroy
    if @address.destroy
      flash[:notice] = "Successfully deleted"
    else
      flash[:error] = "Problems deleting"
    end
    redirect_to cv_instance_path(@cv)
  end


  private
    def find_address
      @address = @cv.address
    end
    
    def load_section
    end
    
    def check_for_cancel
      redirect_to cv_address_path(@cv) if params[:cancel]
    end
end
