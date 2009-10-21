class Presentation < ActiveRecord::Base
  
  include Author_list

  has_many :authorships, :as=>:publication, :dependent=>:destroy
  has_many :authors, :through=>:authorships
  
  before_destroy :destroy_empty_authors

  
  private
    def destroy_empty_authors
      authors.each do |a|
        a.destroy if a.authorships.count == 0
      end
    end
end
