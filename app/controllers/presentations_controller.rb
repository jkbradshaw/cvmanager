class PresentationsController < CvBaseController

  
  def index
    @all = @cv.presentations
    @all.sort! {|x,y| y.given_at <=> x.given_at }
    super
  end
  
  def new
    @one = Presentation.new
    super
  end
  
  def create
    @one = Presentation.new(params[:presentation])
    super
  end

  
  private    
    def load_section
      @one = Presentation.find(params[:id])
    end
end