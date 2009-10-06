require 'test_helper'

class AuthorsControllerTest < ActionController::TestCase
  cv = Cv.make
  author = Author.make(:cv=>cv)
  unassociated = Author.make(:cv=>nil)
  owner = cv.user
  not_owner = User.make(:username=>"not#{owner.username}")
  manager = User.make(:username=>"manager#{owner.username}")
  manager.has_role!(:manager,cv)
  admin = User.make(:username=>"admin#{owner.username}")
  admin.has_role!(:admin)
  
  context "not logged in" do
    context "get index" do
      should "redirect to root" do
        get :index, {:cv_instance_id=>cv.id}
        assert_redirected_to root_url
      end
    end
  end

  context "logged in but no role for cv" do
    setup do
      activate_authlogic
      UserSession.create(not_owner)      
    end

    context "get index" do
      should "redirect to root" do
        get :index,  {:cv_instance_id=>cv.id}
        assert_redirected_to root_url
      end
    end
  end
  
  context "logged in, owner of cv" do
    setup do
      activate_authlogic
      UserSession.create(owner)
    end
    
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
        assert_redirected_to cv_authors_path(cv)
      end
    end

    context "remove action" do
      should "redirect to index when canceled without ignoring the author" do
        post :remove, {:cv_instance_id=>cv.id, :id=>author.id, :cancel=>'cancel'}
        assert ! cv.ignored?(author)
        assert_redirected_to cv_authors_path(cv)
      end
    end

    context "destroy action" do
      should "redirect to index when canceled without unassociating the author" do
        delete :destroy, {:cv_instance_id=>cv.id, :id=>author.id, :cancel=>'cancel'}
        assert cv.authors.include?(author)
        assert_redirected_to cv_authors_path(cv)
      end
    end
    
    
  end
  
  context "logged in, manager of cv" do
    setup do
      activate_authlogic
      UserSession.create(manager)
    end
    
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
        assert_redirected_to cv_authors_path(cv)
      end
    end

    context "remove action" do
      should "redirect to index when canceled without ignoring the author" do
        post :remove, {:cv_instance_id=>cv.id, :id=>author.id, :cancel=>'cancel'}
        assert ! cv.ignored?(author)
        assert_redirected_to cv_authors_path(cv)
      end
    end

    context "destroy action" do
      should "redirect to index when canceled without unassociating the author" do
        delete :destroy, {:cv_instance_id=>cv.id, :id=>author.id, :cancel=>'cancel'}
        assert cv.authors.include?(author)
        assert_redirected_to cv_authors_path(cv)
      end
    end
    
    
  end
  
  context "logged in as admin" do
    setup do
      activate_authlogic
      UserSession.create(admin)
    end
    
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
        assert_redirected_to cv_authors_path(cv)
      end
    end

    context "remove action" do
      should "redirect to index when canceled without ignoring the author" do
        post :remove, {:cv_instance_id=>cv.id, :id=>author.id, :cancel=>'cancel'}
        assert ! cv.ignored?(author)
        assert_redirected_to cv_authors_path(cv)
      end
    end

    context "destroy action" do
      should "redirect to index when canceled without unassociating the author" do
        delete :destroy, {:cv_instance_id=>cv.id, :id=>author.id, :cancel=>'cancel'}
        assert cv.authors.include?(author)
        assert_redirected_to cv_authors_path(cv)
      end
    end
    
    
  end

  
    

  
end