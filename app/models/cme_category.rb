class CmeCategory < ActiveRecord::Base
  
  before_save :find_a_match
  
  def find_a_match
    @j = CmeCategory.category_is(self.category)
    if @j.count > 0
      self.attributes = @j.first.attributes
      self.id = @j.first.id
      false
    end
  end
  
end
