require 'test_helper'

class BookTest < ActiveSupport::TestCase
   should_have_many :authors, :through=>:authorships
   should_have_many :authorships
   should_validate_presence_of :book_title

    
  
end
  