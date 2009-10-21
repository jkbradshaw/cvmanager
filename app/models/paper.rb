class Paper < ActiveRecord::Base
  
  include Author_list

  has_many :authorships, :as=> :publication, :dependent => :destroy
  has_many :authors, :through=>:authorships
  belongs_to :journal
  accepts_nested_attributes_for :journal
  
  validates_presence_of :title
  #validates_uniqueness_of :pmid, :on => :create, :message =>"Paper already in database"
  #validates_format_of :pmid, :with => /^\d{5,}$/, :message => "Pubmed id must be all digits"
  
  before_destroy :destroy_empty_authors
  
  def author_position(author)
    authorships.find_by_author_id(author.id).author_position
  end
  
  def author_at_position(position)
    authorships.find_by_author_position(position).author
  end
  
  def published_in?(year)
    year = year.to_i
    pmed_date.year == year
  end
  
  def self.new_from_pmid(pmid)
    x = get_pubmed_xml(pmid)
    return nil unless x
    h = pubmed_xml_to_hash(x)
    p = Paper.new(h[:paper_info])
    
    h[:author_array].each do |a|
      auth = Author.first_name_is(a[:first_name]).last_name_is(a[:last_name]).first || Author.new({:last_name => a[:last_name], :first_name=> a[:first_name]})
      p.authorships.build({:author=>auth, :author_position=> a[:author_position].to_i})
    end
    
    if h[:journal_info][:nlmuid].empty?
      p.journal = Journal.find_by_issn(h[:journal_info][:issn]) || Journal.new(h[:journal_info])
    else
      p.journal = Journal.find_by_nlmuid(h[:journal_info][:nlmuid]) || Journal.new(h[:journal_info])
    end
    
    p
  end
    
  def self.pubmed_xml_to_hash(paper_xml)
    paper_hash = {}
    
    #paper info
    xpath_base = '//PubmedArticleSet/PubmedArticle/'
    xpath_tags = {
      :pmid => xpath_base + "MedlineCitation/PMID" ,
      :journal_volume => xpath_base + "MedlineCitation/Article/Journal/JournalIssue/Volume" ,
      :journal_issue =>  xpath_base + "MedlineCitation/Article/Journal/JournalIssue/Issue",
      :journal_year => xpath_base + "MedlineCitation/Article/Journal/JournalIssue/PubDate/Year",
      :title =>  xpath_base + "MedlineCitation/Article/ArticleTitle",
      :journal_pages =>  xpath_base + "MedlineCitation/Article/Pagination/MedlinePgn",
      :abstract =>  xpath_base + "MedlineCitation/Article/Abstract/AbstractText",
      :paper_type => xpath_base + "MedlineCitation/Article/PublicationTypeList/PublicationType",
      :pub_model => xpath_base + "MedlineCitation/Article[PubMode]"
    }
    
    paper_hash[:paper_info] = {}
    xpath_tags.each { |key,value| 
      xnode = paper_xml.find(xpath_tags[key])
      paper_hash[:paper_info][key] = xnode.first.content unless xnode.empty?
    }
    
    #journal info
    paper_hash[:journal_info] = {}
    xpath_tags = {
      :issn => xpath_base + "MedlineCitation/Article/Journal/ISSN",
      :long_title => xpath_base + "MedlineCitation/Article/Journal/Title",
      :short_title => xpath_base + "MedlineCitation/MedlineJournalInfo/MedlineTA",
      :nlmuid =>  xpath_base + "MedlineCitation/MedlineJournalInfo/NlmUniqueID"
    }
    xpath_tags.each {|key,value|
      xnode = paper_xml.find(xpath_tags[key])
      paper_hash[:journal_info][key] = xnode.first.content unless xnode.empty?
    }
    
    #add pubmed date
    xpath_date = xpath_base + "PubmedData/History/PubMedPubDate[@PubStatus='pubmed']/"
    ynode = paper_xml.find(xpath_date + "Year")
    mnode = paper_xml.find(xpath_date + 'Month')
    dnode = paper_xml.find(xpath_date + 'Day')
    y, m, d = 1900, 1, 1
    y = ynode.first.content.to_i unless ynode.empty?
    m = mnode.first.content.to_i unless mnode.empty?
    d = dnode.first.content.to_i unless dnode.empty?
    paper_hash[:paper_info][:pmed_date] = Date.civil(y,m,d)
    
    #add authors
    i=0
    paper_hash[:author_array] = []
    xpath_author = '//PubmedArticleSet/PubmedArticle/MedlineCitation/Article/AuthorList/Author'
    paper_xml.find(xpath_author).each do |a|
      l = a.find('LastName')
      f = a.find('ForeName')
      f = a.find('FirstName') if f.empty?
      next if l.empty? || f.empty?
      i=i+1
      lname = l.first.content
      fname = f.first.content
      paper_hash[:author_array] << {:last_name=>lname, :first_name=>fname, :author_position=>i}  
    end
    
    #return paper_hash
    paper_hash     
  end

  def self.get_pubmed_xml(pmid)
    #check for internet connection
    if Ping.pingecho('en.wikipedia.org',2) 
      url = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&&id=' + pmid + '&&retmode=xml'
      xml_data = XML::Parser.file(url)
      xml_doc = xml_data.parse
      if xml_doc.find('//PubmedArticleSet/PubmedArticle/MedlineCitation/PMID').empty? 
        return false
      else 
        return xml_doc
      end
    else
      raise 'No connection to the internet -- cannot retreive information from pubmed'
    end
  end #get_pubmed_xml
  
  private
    def destroy_empty_authors
      self.authors.each do |a|
        a.destroy if a.authorships.count == 0
      end
    end


end
