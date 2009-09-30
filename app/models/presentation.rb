class Presentation < ActiveRecord::Base
  has_many :authorships, :as=>:publication, :dependent=>:destroy
  has_many :authors, :through=>:authorships
  
  before_destroy :destroy_empty_authors
  
  def author_list=(auths)
    auths_array = []
    x = 0
    auths.split(',').each do |a|
      x = x + 1
      b = a.scan(/\w+/)
      l = b.pop
      f = b.join(' ')
      auths_array << {:last_name => l, :first_name => f, :author_position => x}
    end
    
    self.authorships.destroy_all unless self.new_record?
    auths_array.each do |a|
      self.authorships.build({:author=>Author.find_or_create_by_first_and_last_name(a), :author_position=> a[:author_position].to_i})
    end
  end
  
  def author_list
    auths_array = []
    authorships.each do |a|
      auths_array << a.author.first_name + ' ' + a.author.last_name
    end
    auths_array.join(', ')
  end
  
  private
    def destroy_empty_authors
      authors.each do |a|
        a.destroy if a.authorships.count == 0
      end
    end
end
