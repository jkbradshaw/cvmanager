class CvController < CvBaseController

  def show
  end
  
  private
    def find_cv
      @cv = Cv.find(params[:id])
    end

end
