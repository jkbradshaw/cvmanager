class BooksController < CvBaseController
  before_filter :check_for_cancel

  def index
    @books = @cv.books
    @chapters = @cv.chapters
    @add_new_path = new_cv_book_path(@cv)
  end
  
  def new
    @one = Book.new
    super
  end
  
  def create
    @one = Book.new(params[:book])
    if @one.save
      @cv.add_publication(@one) if @cv
      flash[:notice] = "Successfully added to the database."
      redirect_to cv_books_path(@cv) 
    else
      flash[:error] = "Problem adding to the database"
      render :action=>'new'
    end
  end

  
  private    
    def load_section
      @one = Book.find(params[:id])
    end

  
end
