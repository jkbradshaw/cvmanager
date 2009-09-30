require 'test_helper'

class PresentationTest < ActiveSupport::TestCase
  should_have_many :authors
  should_have_many :authorships, :dependent=>:destroy
end
