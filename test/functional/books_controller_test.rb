require 'test_helper'

class BooksControllerTest < ActionController::TestCase

  cv = Cv.make
  author = Author.make
  cv.authors << author
  book = Book.make
  book.authors << author
   
  should_act_as_cv_section_controller(book,cv)
end