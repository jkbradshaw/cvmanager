require 'test_helper'

class EmploymentTest < ActiveSupport::TestCase
  should_belong_to :cv
  should_have_one :institution, :dependent=>:destroy
  should_accept_nested_attributes_for :institution
end
