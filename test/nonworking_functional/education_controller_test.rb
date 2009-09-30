require 'test_helper'

class EducationControllerTest < ActionController::TestCase

  cv = Cv.make
  education = Education.make(:cv=>cv)
  institution = Institution.make(:education, :experience=>education)
  
  should_act_as_cv_section_controller education
end