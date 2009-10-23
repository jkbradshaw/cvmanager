class ActivitiesController < CvBaseController

  undef :show, :new, :create, :edit, :update, :delete, :destroy
  
  def index
    @faculty_appointments = @cv.faculty_appointments.descend_by_end_year.all
    @national_positions = @cv.national_positions.descend_by_end_year.all
    @admin_positions = @cv.admin_positions.descend_by_end_year.all
    @clinical_activities = @cv.clinical_activities.descend_by_end_year.all
  end
  
  private
    
    def set_section
    end
    
    def load_section
    end
    
    def check_for_cancel
    end

end
