require 'test_helper'

class AuthorsControllerTest < ActionController::TestCase
  cv = Cv.make
  author = Author.make(:cv=>cv)
  unassociated = Author.make(:cv=>nil)
  
  
  context "without cv_instance_id" do
    context "show action" do
      should "render show template" do
        get :show, :id=>author.id
        assert_template 'show'
      end
    end
    context "index" do
      should "render index template" do
        get :index
        assert_template 'index'
      end
    end
  end
  
  context "with cv_instance_id" do
    %w[show associate unassociate ignore].each do |action|
      context "#{action} action" do
        should "render #{action} template" do
          get action.to_sym, {:cv_instance_id=>cv.id, :id=>author.id}
          assert_template "#{action}"
        end
      end
    end
    
    context "update action" do 
      should "redirect to index when canceled without associating the author" do
        put :update, {:cv_instance_id=>cv.id, :id=>unassociated.id, :cancel=>'cancel'}
        assert ! cv.authors.include?(unassociated)
        assert_redirected_to cv_authors_path
      end
    end
    
    context "remove action" do
      should "redirect to index when canceled without ignoring the author" do
        post :remove, {:cv_instance_id=>cv.id, :id=>author.id, :cancel=>'cancel'}
        assert ! cv.ignored?(author)
        assert_redirected_to cv_authors_path
      end
    end
    
    context "destroy action" do
      should "redirect to index when canceled without unassociating the author" do
        delete :destroy, {:cv_instance_id=>cv.id, :id=>author.id, :cancel=>'cancel'}
        assert cv.authors.include?(author)
        assert_redirected_to cv_authors_path
      end
    end
    
    
  end
  
end