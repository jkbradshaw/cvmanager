class BooksController < CvBaseController
  before_filter :check_for_cancel

  def index
    @books = @cv.books
    @chapters = @cv.chapters
    @add_new_path = new_cv_book_path(@cv)
  end
  
  def show
  end
  
  def new
    @book = Book.new
  end
  
  def create
    @book = Book.new(params[:book])
    if @book.save
      @cv.add_publication(@book) if @cv
      flash[:notice] = "Successfully added to the database."
      redirect_to cv_books_path(@cv) 
    else
      flash[:error] = "Problem adding to the database"
      redirect_to  new_cv_book_path(@cv)
    end
  end
  
  def edit
    @book = Book.find(params[:id])
  end
  
  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(params[:book])
      flash[:notice] = "Successfully updated"
      redirect_to  cv_books_path(@cv)
    else
      flash[:error] = "Problem updating"
      redirect_to edit_cv_book_path(@cv, @book) 
    end  
  end
  
  def delete
    @book = Book.find(params[:id])
  end
  
  def destroy
    @book = Book.find(params[:id])
    if @book.destroy
      flash[:notice] = "Successfully removed from the database."
    else
      flash[:error] = "Problem removing from the database"
    end
    redirect_to cv_books_url(@cv)
  end
  
  private    
    def check_for_cancel
      redirect_to @cv ? cv_books_path(@cv) : books_path and return if params[:cancel]
    end

  
end
