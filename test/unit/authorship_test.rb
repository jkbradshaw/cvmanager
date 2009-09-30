require 'test_helper'

class AuthorshipTest < ActiveSupport::TestCase
  should_belong_to :author
  should_belong_to :publication
  
  context "deleting an authorship" do
    setup do
      @authorship = Authorship.make(:paper)
      @paper = @authorship.publication
      @author = @authorship.author
      @authorship.destroy
    end
    should "remove an orphaned author" do
      assert !Author.exists?(@author.id)
    end
  end
      
      
end
