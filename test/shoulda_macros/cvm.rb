class Test::Unit::TestCase
  def self.should_act_as_base_controller(section=nil)
    base = self.name.gsub(/ControllerTest$/, '')
    klass = base.singularize.constantize
    controller = base.downcase.pluralize
    
    section ||= klass.make
    
    self.cvm_gets(%w[index])
    self.cvm_gets(%w[new delete edit], {:id=>section.id} )
    self.cvm_create(klass,controller)
    self.cvm_update(klass,controller,{ :id=>section.id})
    self.cvm_destroy(klass,controller,{ :id=>section.id}, section.id)
    self.cvm_edit(klass,controller,{ :id=>section.id})

  end
  
  def self.cvm_gets(actions,params = {})
    actions.each do |action|
      context "#{action} action" do
        should "render #{action} template" do
          get action.to_sym, params
          assert_template action
        end
      end
    end
  end
  
  def self.cvm_create(klass,controller,params={})
    context "create action" do
      should "render new template when model is invalid" do
        klass.any_instance.stubs(:valid?).returns(false)
        post :create, params
        assert_template 'new'
      end

      should "redirect when model is valid" do
        klass.any_instance.stubs(:valid?).returns(true)
        post :create, params
        assert_redirected_to :controller=>controller, :action=>'index'
      end

      should "redirect when canceled" do
        klass.any_instance.stubs(:valid?).returns(true)
        post :create, params.merge({:cancel=>'cancel'})
        assert flash == {}
        assert_redirected_to :controller=>controller, :action=>'index'
      end
    end
  end
  
  def self.cvm_update(klass,controller,params)
    context "update action" do
      should "render edit template when model is invalid" do
        klass.any_instance.stubs(:valid?).returns(false)
        put :update, params
        assert_template 'edit'
      end

      should "redirect when model is valid" do
        klass.any_instance.stubs(:valid?).returns(true)
        put :update, params
        assert_redirected_to :controller=>controller, :action=>'index'
      end

      should "redirect when canceled" do
        klass.any_instance.stubs(:valid?).returns(true)
        put :update, params.merge({:cancel=>'cancel'})
        assert flash == {}
        assert_redirected_to :controller=>controller, :action=>'index'
      end
    end
  end
  
  def self.cvm_destroy(klass,controller,params,section_id)
    context "destroy action" do
      should "destroy model and redirect to index action" do
        delete :destroy, params
        assert !klass.exists?(section_id)
        assert_redirected_to :controller=>controller, :action=>'index'
      end

      should "redirect when canceled" do
        delete :destroy, params.merge({:cancel=>'cancel'})
        assert klass.exists?(section_id)
        assert_redirected_to  :controller=>controller, :action=>'index'
      end
    end
  end
  
  def self.cvm_edit(klass,controller,params)
    context "edit action" do
      should "redirect when canceled" do
        klass.any_instance.stubs(:valid?).returns(true)
        post :edit, params.merge({:cancel=>'cancel'})
        assert_redirected_to :controller=>controller, :action=>'index'
      end
    end
  end
  
  
  def self.should_act_as_cv_section_controller(section = nil,cv = nil)
    base = self.name.gsub(/ControllerTest$/, '')
    klass = base.singularize.constantize
    controller = base.downcase.pluralize
    
    section ||= klass.make
    cv ||= section.cv
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
    
      self.cvm_gets(%w[index], {:cv_instance_id => cv.id})
      self.cvm_gets(%w[new delete edit], {:cv_instance_id=>cv.id, :id=>section.id} )
      self.cvm_create(klass,controller,{:cv_instance_id=>cv.id})
      self.cvm_update(klass,controller,{:cv_instance_id=>cv.id, :id=>section.id})
      self.cvm_destroy(klass,controller,{:cv_instance_id=>cv.id, :id=>section.id}, section.id)
      self.cvm_edit(klass,controller,{:cv_instance_id=>cv.id, :id=>section.id})    
    end
    
    context "logged in, manager of cv" do
      setup do
        activate_authlogic
        UserSession.create(manager)
      end
    
      self.cvm_gets(%w[index], {:cv_instance_id => cv.id})
      self.cvm_gets(%w[new delete edit], {:cv_instance_id=>cv.id, :id=>section.id} )
      self.cvm_create(klass,controller,{:cv_instance_id=>cv.id})
      self.cvm_update(klass,controller,{:cv_instance_id=>cv.id, :id=>section.id})
      self.cvm_destroy(klass,controller,{:cv_instance_id=>cv.id, :id=>section.id}, section.id)
      self.cvm_edit(klass,controller,{:cv_instance_id=>cv.id, :id=>section.id})    
    end
    
    context "logged in as admin" do
      setup do
        activate_authlogic
        UserSession.create(admin)
      end
    
      self.cvm_gets(%w[index], {:cv_instance_id => cv.id})
      self.cvm_gets(%w[new delete edit], {:cv_instance_id=>cv.id, :id=>section.id} )
      self.cvm_create(klass,controller,{:cv_instance_id=>cv.id})
      self.cvm_update(klass,controller,{:cv_instance_id=>cv.id, :id=>section.id})
      self.cvm_destroy(klass,controller,{:cv_instance_id=>cv.id, :id=>section.id}, section.id)
      self.cvm_edit(klass,controller,{:cv_instance_id=>cv.id, :id=>section.id})    
    end
    
  end
  
end
