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
 
  end
  


end
