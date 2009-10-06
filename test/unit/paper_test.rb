require 'test_helper'

class PaperTest < ActiveSupport::TestCase

  context "A Paper instance" do
    setup do
      @p = Paper.make
    end

    should_belong_to :journal
    should_validate_uniqueness_of :pmid, :message=>"Paper already in database"
    should_have_many :authors, :through=>:authorships
    should_validate_presence_of :title, :pmid
    should_allow_values_for :pmid, '1865734', '164432'
    should_not_allow_values_for :pmid, 'asdfer', '1234', '18764d'
 
    context "with Author 'A' as first author" do
      setup do
        @a = Author.make
        @p.authorships.create({:author=>@a, :author_position=>1})
      end
      
      should "report author position for 'A' as 1" do
        assert @p.author_position(@a) == 1
      end
    end
    
    context "published in 2009" do
      setup do
        @p.pmed_date = Date.civil(2009,5,4)
      end
      
      should "report true to published_in? 2009" do
        assert @p.published_in?(2009)
      end
    end
      
 
  end
  


end
