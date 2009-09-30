class Admin::JournalsController < Admin::AdminController
  
  before_filter :check_for_cancel
  
  def index
    @journals = Journal.find(:all, :order=>'impact DESC')
  end
  
  def show
    @journal = Journal.find(params[:id])
    @papers = @journal.papers.find(:all, :order=>'pmed_date DESC')
  end
  
  def new
    @journal = Journal.new
  end
  
  def create
    @journal = Journal.new(params[:journal])
    if @journal.save
      flash[:notice] = "Successfully created."
      redirect_to admin_journals_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @journal = Journal.find(params[:id])
  end
  
  def update
    @journal = Journal.find(params[:id])
    if @journal.update_attributes(params[:journal])
      flash[:notice] = "Successfully updated."
      redirect_to admin_journals_url
    else
      render :action => 'edit'
    end
  end
  
  def delete
    @journal = Journal.find(params[:id])
  end
  
  def destroy
    @journal = Journal.find(params[:id])
    if @journal.papers.count > 0
      flash[:error] = "Can't remove this journal because there are associated papers in the database"
    else
      @journal.destroy
      flash[:notice] = "Successfully removed."
    end
    redirect_to admin_journals_url
  end
  
  private
    def check_for_cancel
      redirect_to admin_journals_path if params[:cancel]
    end
end
