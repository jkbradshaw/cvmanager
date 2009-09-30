require 'test_helper'

class FacultyTest < ActiveSupport::TestCase
    
  should_belong_to :section
  should_belong_to :user
  should_delegate :cv, :to=>:user
  should_delegate :name, :last_name, :first_name, :to=>:user

  
end
