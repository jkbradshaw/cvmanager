class Paper < ActiveRecord::Base

  has_many :authorships, :as=> :publication, :dependent => :destroy
  has_many :authors, :through=>:authorships
  belongs_to :journal
  
  validates_presence_of :pmid, :title
  validates_uniqueness_of :pmid, :on => :create, :message =>"Paper already in database"
  validates_format_of :pmid, :with => /^\d{5,}$/, :message => "Pubmed id must be all digits"
  
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
  
  def author_array=(auths)
    if self.new_record?
      auths.each do |key,a|
        self.authorships.build({:author=>Author.find_or_create_by_first_and_last_name(a), :author_position=> a[:author_position].to_i})
      end
    end
  end

  def journal_info=(journal)
    if self.new_record?
      if journal[:nlmuid].empty?
        self.journal = Journal.find_by_issn(journal[:issn]) || Journal.new(journal)
      else
        self.journal = Journal.find_by_nlmuid(journal[:nlmuid]) || Journal.new(journal)
      end
    end
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
    
    xpath_tags.each { |key,value| 
      xnode = paper_xml.find(xpath_tags[key])
      paper_hash[key] = xnode.first.content unless xnode.empty?
    }
    
    #journal info
    paper_hash[:journal] = {}
    xpath_tags = {
      :issn => xpath_base + "MedlineCitation/Article/Journal/ISSN",
      :long_title => xpath_base + "MedlineCitation/Article/Journal/Title",
      :short_title => xpath_base + "MedlineCitation/MedlineJournalInfo/MedlineTA",
      :nlmuid =>  xpath_base + "MedlineCitation/MedlineJournalInfo/NlmUniqueID"
    }
    xpath_tags.each {|key,value|
      xnode = paper_xml.find(xpath_tags[key])
      paper_hash[:journal][key] = xnode.first.content unless xnode.empty?
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
    paper_hash[:pmed_date] = Date.civil(y,m,d)
    
    #add authors
    i=0
    paper_hash[:authors] = []
    xpath_author = '//PubmedArticleSet/PubmedArticle/MedlineCitation/Article/AuthorList/Author'
    paper_xml.find(xpath_author).each do |a|
      l = a.find('LastName')
      f = a.find('ForeName')
      f = a.find('FirstName') if f.empty?
      next if l.empty? || f.empty?
      i=i+1
      lname = l.first.content
      fname = f.first.content
      paper_hash[:authors] << {:last_name=>lname, :first_name=>fname, :author_position=>i}  
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
