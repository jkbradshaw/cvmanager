class AuthorsController < CvBaseController
  
  before_filter :check_for_cancel

  def index
    @authors = @cv.authors
    @possible_authors = @cv.possible_authors
  end
  
  def show
    @author = Author.find(params[:id])
  end
  
  # associate/update pair
  def associate  
    @author = Author.find(params[:id])
  end
  
  def update
    @author = Author.find(params[:id])
    if @cv.add_authors(@author)
      flash[:notice] = "Successfully associated."
    else
      flash[:error] = "Problem associating"
    end
    redirect_to cv_authors_path(@cv)
  end
  
  # ignore/remove pair
  def ignore
    @author = Author.find(params[:id])
  end
  
  def remove
    @author = Author.find(params[:id])
    if @cv.ignore_authors(@author)
      flash[:notice] = "Successfully ignored"
    else
      flash[:error] = "Problem ignoring"
    end
    redirect_to cv_authors_path(@cv)
  end

  # unassociate/destroy pair
  def unassociate
    @author = Author.find(params[:id])
  end
  
  def destroy
    @author = Author.find(params[:id])
    if @cv.remove_authors(@author)
      flash[:notice] = "Successfully unassociated"
    else
      flash[:error] = "Problem unassociating"
    end
    redirect_to cv_authors_path(@cv)
  end
  
  private
    def check_for_cancel
      redirect_to cv_authors_path(@cv) if params[:cancel]
    end
    
  
end
