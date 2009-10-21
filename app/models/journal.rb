class Journal < ActiveRecord::Base
  has_many :papers
  
  before_save :find_a_match
  
  def find_a_match
    @j = Journal.long_title_or_short_title_or_issn_or_nlmuid_is_any(self.long_title,self.short_title,self.issn,self.nlmuid)
    if @j.count > 0
      self.attributes = @j.first.attributes
      self.id = @j.first.id
      false
    end
  end
  
end
