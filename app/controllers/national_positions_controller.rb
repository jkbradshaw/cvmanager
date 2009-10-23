class NationalPositionsController < CvBaseController
  undef :show
  
  def index
    redirect_to :controller=>'activities', :action=>'index'
  end
  
end