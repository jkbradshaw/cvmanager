class AuthorsController < CvBaseController
  
  layout 'authorships'
  before_filter :load_author, :except => [:index, :search]
  
  undef :edit, :new, :create
  
  def index
    @authors = @cv.authors
    @possible_authors = @cv.possible_authors
  end
  
  def show
  end
  
  def search
    @query = true if params[:search] and params[:search].values.uniq.reject{|x| x==nil or x==''}.size > 0
    @results = Author.search(params[:search].merge({:unassigned=>true})).all - @cv.coauthors if @query
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  # associate/update pair
  def associate  
  end
  
  def update
    if @cv.add_authors(@author)
      flash[:notice] = "Successfully associated."
    else
      flash[:error] = "Problem associating"
    end
    redirect_to cv_authors_path(@cv)
  end
  
  # ignore/remove pair
  def ignore
  end
  
  def remove
    if @cv.ignore_authors(@author)
      flash[:notice] = "Successfully ignored"
    else
      flash[:error] = "Problem ignoring"
    end
    redirect_to cv_authors_path(@cv)
  end

  # unassociate/destroy pair
  def unassociate
  end
  
  def destroy
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
    
    def load_author
      @author = Author.find(params[:id])
    end
    
    def load_section
    end
    
  
end
