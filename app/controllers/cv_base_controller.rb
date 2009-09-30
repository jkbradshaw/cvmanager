class CvBaseController < ApplicationController
  layout 'cv'
  
  before_filter :find_cv
  before_filter :set_context

  access_control do
    allow :admin
    allow :owner, :manager, :of=>:cv
  end
  
  private
    def find_cv
      @cv = Cv.find(params[:cv_instance_id]) if params[:cv_instance_id]
    end
    
    def set_context
      set_user_context(@cv.user)
    end
    
end