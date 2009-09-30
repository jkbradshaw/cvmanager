require 'test_helper'

class JournalTest < ActiveSupport::TestCase
  context "A journal" do
    setup do 
      @j = Journal.make
    end
    
    should_have_many :papers
  end
end
