require 'test_helper'

class IgnoredAuthorTest < ActiveSupport::TestCase
  should_belong_to :cv
  should_belong_to :author
  should_delegate :last_name, :first_name, :name, :to=>:author
end
