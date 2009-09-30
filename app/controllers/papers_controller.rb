class PapersController < CvBaseController

  def index
    @papers = @cv.papers
  end
  
  def show
  end 
  
  def new
  end 
  
  def create
    redirect_to new_cv_paper_path(@cv) and return if params[:cancel]
    paper_params = params[:paper]
    paper_params[:author_array] = params[:authors]
    paper_params[:journal_info] = params[:journal]
     
    if @paper = Paper.create(paper_params)
      @cv.add_publication(@paper) if @cv
      respond_to do |format|
        format.html {
          flash[:notice] = 'Paper added'
          redirect_to cv_papers_path(@cv)
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:notice] = 'Problem adding paper to the database'
          redirect_to cv_papers_path(@cv)
        }
      end
    end
  end
  

  def preview
    pmid = params["params"]["pmid"]
    
    if !pmid or pmid == ''
      flash[:error] = 'Search field cannot be blank'
    elsif (pmid =~ /^\d{4,}$/).nil? 
      flash[:error] = 'Pubmed id must be all digits and at least 4 digits long'
    else
      if x = Paper.get_pubmed_xml(pmid)
        @paper = Paper.pubmed_xml_to_hash(x)
        flash[:error] = "The paper: <br/><em>#{@paper[:title]}</em><br/> is already in the database" if Paper.find_by_pmid(@paper[:pmid])
      else
        flash[:error] = "No paper with pubmed id of #{pmid}"
      end
    end
    
    return render :action=>"new" if flash[:error] 
    
    respond_to do |format|
      format.html #preview.html.erb
      format.xml { }
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
  
  private
  
    def load_cv
      if params[:cv_instance_id]
        @cv = Cv.find(params[:cv_instance_id])
      else
        @cv = nil
      end
    end
    


  
  
end
