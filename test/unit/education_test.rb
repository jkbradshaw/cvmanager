require 'test_helper'

class EducationTest < ActiveSupport::TestCase
  should_belong_to :cv
  should_have_one :institution
  should_accept_nested_attributes_for :institution

end
