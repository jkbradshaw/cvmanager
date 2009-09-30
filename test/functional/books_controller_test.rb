require 'test_helper'

class BooksControllerTest < ActionController::TestCase

  cv = Cv.make
  author = Author.make
  cv.authors << author
  book = Book.make
  book.authors << author
   
  context "no cv_instance_id" do
    should_act_as_base_controller
  end
  
  context "with cv_instance_id" do
    should_act_as_cv_section_controller(book,cv)
  end
end