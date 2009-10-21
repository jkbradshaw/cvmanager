class PapersController < CvBaseController

  def index
    @papers = @cv.papers
    @papers.sort! {|x,y| y.journal_year <=> x.journal_year}
  end
  
  def show
  end 
  
  def new
    @paper = Paper.new
    @journal_attributes = :journal_attributes
    respond_to do |format|
      format.html
    end
  end 
  
  def create
    redirect_to cv_papers_path(@cv) and return if params[:cancel]
    

    @paper = Paper.new(params[:paper])
    if @paper.save
      @cv.add_publication(@paper)
      flash[:notice] = 'Paper added'
      redirect_to cv_papers_path(@cv)
    else
      flash[:error] = 'Problem adding paper to the database'
      render :action=>'new'
    end
  end
  

  def preview
    pmid = params["params"]["pmid"]
    
    @paper = Paper.new_from_pmid(pmid)
    @journal_attributes = :journal
    
    respond_to do |format|
      format.html do
        unless @paper
          flash[:error] = "No paper with pubmed id of #{pmid}"
          redirect_to new_cv_paper_path(@cv)
        end
      end
      
      format.js 
    end
    
  end
  
  def edit
    @paper = Paper.find(params[:id])
  end
  
  def update
    redirect_to cv_papers_path(@cv) and return if params[:cancel]
    
    @paper = Paper.find(params[:id])
    if @paper.update_attributes(params[:paper])
      flash[:notice] = "Successfully updated"
      redirect_to cv_papers_path(@cv)
    else
      flash[:error] = "Problems updating"
      render :action => 'edit'
    end
  end
  
  def delete
    @paper = Paper.find(params[:id])
  end
  
  #DELETE /papers/1
  def destroy
    redirect_to cv_papers_path(@cv) and return if params[:cancel]
    @paper = Paper.find(params[:id])
    @paper.destroy
    flash[:notice] = "Successfully removed from the database."
    redirect_to cv_papers_url(@cv)
  end
  

  
end
