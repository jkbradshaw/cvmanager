class Author < ActiveRecord::Base
  
  has_many :papers, :through=>:authorships, :source=>:publication, :source_type=>"Paper"
  has_many :books, :through=>:authorships, :source=>:publication, :source_type=>"Book"
  has_many :presentations, :through=>:authorships, :source=>:publication, :source_type=>'Presentation'
  has_many :authorships
  belongs_to :cv
  
  named_scope :unassigned, :conditions => {:cv_id => nil}
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def publications
    papers + books + presentations
  end
  
  def self.find_or_create_by_first_and_last_name(name_hash)
    name_hash = self.array_to_hash(name_hash) if name_hash.class == Array
    self.find_by_last_name_and_first_name(name_hash[:last_name], name_hash[:first_name]) || self.new({:last_name => name_hash[:last_name], :first_name => name_hash[:first_name]})
  end
  
  
  private
    def self.array_to_hash(array)
      b = {}
      array.each{|x| b.merge!(x) }
      b
    end

end
