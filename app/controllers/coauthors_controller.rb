class CoauthorsController < CvBaseController
  before_filter :get_coauthors
  
  layout 'authorships'
  
  undef :index, :new, :create, :delete, :destroy
  
  def show
  end
  
  def edit
  end
  
  def update
    unless params[:cancel] or params['coauthor'].nil?
      @coauthors.each do |c|
        if params['coauthor'].include?(c.id.to_s)
          c.trainee = true
          c.save
        else
          c.trainee = false
          c.save
        end
      end
    end

    redirect_to cv_coauthors_url(@cv)
  end
  
  private
    def get_coauthors
      @coauthors = @cv.coauthors(Time.now.year).sort {|x,y| x.last_name.downcase <=> y.last_name.downcase}
    end
    
    def set_section
    end
    
    def load_section
    end
    
    def check_for_cancel
      redirect_to :action=>'show' if params[:cancel]
    end
  
end