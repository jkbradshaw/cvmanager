class Public::CvController < Public::PublicController
  
  def summary
    @papers=Paper.find(:all, :limit=>5, :order=>'pmed_date DESC')
    @books = Book.find(:all)
    @cme_hours = Cme.sum('hours')
  end
  
  def public_cv
    redirect_to public_summary_path unless params[:name]
    unless @cv = Cv.find_by_public_address(params[:name])
      flash[:error] = "No CV for #{params[:name]}"
      redirect_to public_summary_path
    end
  end
  
end
