class Cv < ActiveRecord::Base
  
  acts_as_authorization_object
  
  #attr_accessible :user_id
  has_many :authors
  has_many :ignored_authors
  has_many :education
  has_many :awards 
  has_many :memberships
  has_many :certifications
  has_many :employment
  has_many :training
  has_one :address
  belongs_to :user
  
  delegate :last_name, :first_name, :name, :to=>:user
  
  before_save :make_public_address
  after_save :set_ownership
  
  def first_authorship_papers(date)
    paps = []
    authors.each do |author|
      author.papers.each do |p|
        paps << p if p.author_position(author) == 1 and p.pmed_date > date
      end
    end
    paps.flatten!
    paps
  end
  
  def second_authorship_papers_with_trainee(date)
    paps = []
    authors.each do |author|
      author.papers.each do |p|
        paps << p if p.author_position(author) == 2 and p.author_at_position(2).trainee and p.pmed_date > date
      end
    end
    paps.flatten!
    paps
  end
  
  def papers
    paper_list = []
    authors.each do |a|
      a.papers.each do |p|
       paper_list << p if p
      end
    end 
    paper_list
  end
     
  def books
    book_list = []
    authors.each do |a|
      a.books.each do |b|
        book_list << b if b and !b.is_chapter
      end
    end
    book_list
  end
  
  def chapters
    chapter_list = []
    authors.each do |a|
      a.books.each do |b|
        chapter_list << b if b and b.is_chapter
      end
    end
    chapter_list
  end
  
  def books_and_chapters(year = nil)
    list = []
    authors.each do |a|
      if year
        list << a.books.year_is(year).all
      else
        list << a.books
      end
    end
    list.uniq!
    list.flatten!
    list
  end
  
  def managers
    roles = Role.authorizable_type_is('Cv').authorizable_id_is(self.id).name_is('manager').all
    managers = roles.map {|r| r.users}
    managers.flatten!
    managers
  end
  
  def coauthors(year = nil)
    auth_list = []
    papers.each do |paper|
      if year
        auth_list << paper.authors if paper.published_in?(year)
      else
        auth_list << paper.authors
      end
    end
    auth_list.flatten!
    auth_list.uniq!
    auth_list.reject! {|x| self.authors.include?(x) }
    auth_list
  end    

  def ignored?(author)
    ia = []
    ignored_authors.each do |i|
      ia << i.author
    end
    ia.include?(author)
  end
  
  def publication_author?(publication)
    intersection = authors & publication.authors
    if intersection.empty?
      false
    else
      true
    end
  end
  
  def possible_authors
    author_list_scope = Author.last_name_like(last_name).first_name_like(first_name.split(' ')[0].chars.to_a[0]).cv_id_null
    author_list = author_list_scope.all.reject {|author| ignored?(author)}
    return nil if author_list.empty?
    author_list
  end
  
  def find_publication_author(publication)
    return false if publication_author?(publication)  #publication author already associated with faculty member
    author_list_scope = publication.authors.last_name_like(last_name)
    return false if author_list_scope.count == 0
    author_list_scope = author_list_scope.first_name_like(first_name) if author_list_scope.count > 1
    return false unless author_list_scope.count == 1
    author_list_scope.first
  end
  
  def add_authors(author_list)
    author_list = [author_list] unless author_list.class == Array
    author_list = author_list - authors
    author_list.each do |a|
      self.authors << a
    end
    author_list
  end
  
  def ignore_authors(author_list)
    starting_ignored_count = self.ignored_authors.count
    author_list = [author_list] unless author_list.class == Array
    author_list.each do |author|
      self.ignored_authors.create(:author=>author) unless self.ignored?(author)
    end
    if self.ignored_authors.count - starting_ignored_count > 0
      true
    else
      false
    end
  end  
    
  def remove_authors(author_list)
    author_list = [author_list] unless author_list.class == Array
    self.authors = self.authors - author_list
  end
  
  def add_publication(pub)
    return false if pub.authors.empty?
    if pa = find_publication_author(pub)
      add_authors(pa)
      true
    else
      false
    end
  end
  
  private
    def make_public_address
      pcv = first_name.split(' ')[0].to_s.capitalize + last_name.capitalize
      others = Cv.public_address_like(pcv)
      if others.count > 0
        others = others.descend_by_public_address
        opcv = others.first.public_address
        pcv = opcv.match(/\d$/) ? opcv.succ : opcv + '1'
      end
      self.public_address = pcv 
    end

    def set_ownership
      user.has_role!(:owner, self)
    end

end
