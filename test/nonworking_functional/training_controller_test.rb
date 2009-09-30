require 'test_helper'

class TrainingControllerTest < ActionController::TestCase

  cv = Cv.make
  training = Training.make(:cv=>cv)
  institution = Institution.make(:training, :experience=>training)
  
  should_act_as_cv_section_controller training
end