class EmploymentController < CvBaseController

  def new
    @institution_fields = :institution_attributes
    super
  end

  def edit
    @institution_fields = :institution
    super
  end
 
end
       