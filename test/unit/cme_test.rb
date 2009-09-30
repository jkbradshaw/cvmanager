require 'test_helper'

class CmeTest < ActiveSupport::TestCase

  should_belong_to :user
  should_belong_to :cme_category
  should_delegate :category, :to=>:cme_category
end
