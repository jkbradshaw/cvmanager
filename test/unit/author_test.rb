require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
  should_have_many :papers, :through=>:authorships
  should_have_many :books, :through=>:authorships
  should_have_many :presentations, :through=>:authorships
  should_have_many :authorships
  should_belong_to :cv
  
  test "find or create" do
    @author1 = Author.make
    @author2 = Author.find_or_create_by_first_and_last_name({:first_name=>@author1.first_name, :last_name=>@author1.last_name})
    assert !@author2.new_record?
  end
  
      
end
