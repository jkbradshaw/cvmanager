require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  setup {@section = Section.make}
  
  context "A section instance" do
    should_have_many :faculty
  end
  
  context "Destroying a section instance" do
    setup do
      @section = Section.make
      @faculty = Faculty.make(:section=>@section)
      @section.destroy
      @faculty.reload
    end
    
    should "not destroy associated faculty record" do
      assert Faculty.find(@faculty.id)
    end
    
    should "nullify associated faculty record" do
      assert_nil @faculty.section_id
    end
  end
  
end
