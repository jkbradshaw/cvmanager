class CvController < CvBaseController

  undef :index, :new, :create, :edit, :update, :delete, :destroy
  
  def show
  end
  
  private
    def find_cv
      @cv = Cv.find(params[:id])
    end
    
    def set_section
    end
    
    def load_section
    end

end
