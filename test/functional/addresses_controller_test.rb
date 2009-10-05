require 'test_helper'

class AddressesControllerTest < ActionController::TestCase
  
  address = Address.make
  cv = address.cv
  owner = cv.user
  not_owner = User.make(:username=>"not#{owner.username}")
  manager = User.make(:username=>"manager#{owner.username}")
  manager.has_role!(:manager,cv)
  admin = User.make(:username=>"admin#{owner.username}")
  admin.has_role!(:admin)
  
  context "not logged in" do
    context "get show" do
      should "redirect to root" do
        get :show, {:cv_instance_id=>cv.id}
        assert_redirected_to root_url
      end
    end
  end

  context "logged in but no role for cv" do
    setup do
      activate_authlogic
      UserSession.create(not_owner)      
    end

    context "get show" do
      should "redirect to root" do
        get :show,  {:cv_instance_id=>cv.id}
        assert_redirected_to root_url
      end
    end
  end
  
  context "logged in, owner of cv" do
    setup do
      activate_authlogic
      UserSession.create(owner)
    end
    
    context "get show" do
      should "display show template" do
        get :show, {:cv_instance_id=>cv.id}
        assert_template 'show'
      end
    end
    
    context "get new" do
      should "display new template" do
        get :new, {:cv_instance_id=>cv.id}
        assert_template 'new'
      end
    end
    
    context 'get edit' do
      should 'display edit template' do
        get :edit, {:cv_instance_id=>cv.id}
        assert_template 'edit'
      end
    
      should "redirect when canceled" do
        Address.any_instance.stubs(:valid?).returns(true)
        post :edit, {:cv_instance_id=>cv.id, :cancel=>'cancel'}
        assert_redirected_to cv_address_path(cv)
      end
    end
    
    context 'update action' do
      should "render edit template when model is invalid" do
        Address.any_instance.stubs(:valid?).returns(false)
        put :update, {:cv_instance_id=>cv.id}
        assert_template 'edit'
      end

      should "redirect when model is valid" do
        Address.any_instance.stubs(:valid?).returns(true)
        put :update, {:cv_instance_id=>cv.id}
        assert_redirected_to cv_address_path(cv)
      end

      should "redirect when canceled" do
        Address.any_instance.stubs(:valid?).returns(true)
        put :update, {:cv_instance_id=>cv.id, :cancel=>'cancel'}
        assert flash == {}
        assert_redirected_to cv_address_path(cv)
      end
    end
    
    context "destroy action" do
      should "destroy model and redirect to index action" do
        delete :destroy, {:cv_instance_id=>cv.id}
        assert !Address.exists?(address.id)
        assert_redirected_to cv_instance_path(cv)
      end

      should "redirect when canceled" do
        delete :destroy, {:cv_instance_id=>cv.id, :cancel=>'cancel'}
        assert Address.exists?(address.id)
        assert_redirected_to  cv_address_path(cv)
      end
    end
    
  end
  
end