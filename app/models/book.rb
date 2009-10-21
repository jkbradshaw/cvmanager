class Book < ActiveRecord::Base
  
  include Author_list

  has_many :authorships, :as=>:publication, :dependent=>:destroy
  has_many :authors, :through=>:authorships
  
  validates_presence_of :book_title
  validates_format_of :pages, :with=>/^[\d-]+$/
  
  validate :author_list_commas
  
  before_destroy :destroy_empty_authors
  before_save :book_or_chapter
  
  
  private
    def destroy_empty_authors
      authors.each do |a|
        a.destroy if a.authorships.count == 0
      end
    end
  
    def book_or_chapter
      self.is_chapter = true unless chapter_title.nil? or chapter_title.empty?
    end
    
    def year_must_be_reasonable
      errors.add(:year, "Year must be between 1950 and the current year") unless self.year.to_i === (1950..Date.today.year.to_i)
    end
    
    
    def author_list_commas
      errors.add(:author_list, "Separate authors using commas. Names should be listed: John Smith, Jane P Smith, etc") if self.author_list.to_s.match(/[;:]/)
    end
    
end
