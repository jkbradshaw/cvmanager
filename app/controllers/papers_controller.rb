class PapersController < CvBaseController

  def index
    @all = @cv.papers
    @all.sort! {|x,y| y.journal_year <=> x.journal_year}
    super
  end

  
  def new
    @one = Paper.new
    @journal_attributes = :journal_attributes
  end 
  
  def create
    @one = Paper.new(params[:paper])
    if @one.save
      @cv.add_publication(@one)
      flash[:notice] = 'Paper added'
      redirect_to cv_papers_path(@cv)
    else
      flash[:error] = 'Problem adding paper to the database'
      render :action=>'new'
    end
  end
  

  def preview
    pmid = params["params"]["pmid"]
    
    @one = Paper.new_from_pmid(pmid)
    @journal_attributes = :journal
    
    respond_to do |format|
      format.html do
        unless @one
          flash[:error] = "No paper with pubmed id of #{pmid}"
          redirect_to new_cv_paper_path(@cv)
        end
      end
      format.js 
    end
    
  end
  
  
  private
    def load_section
      @one = Paper.find(params[:id])
    end
  

  
end
