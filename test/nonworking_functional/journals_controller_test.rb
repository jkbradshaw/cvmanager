require 'test_helper'

class JournalsControllerTest < ActionController::TestCase
  setup do
    @journal = Journal.make
  end
  
  context "index action" do
    should "render index template" do
      get :index
      assert_template 'index'
    end
  end
  
  context "show action" do
    should "render show template" do
      get :show, :id=>Journal.first
      assert_template 'show'
    end
  end
  
  context "new action" do
    should "render new template" do
      get :new
      assert_template 'new'
    end
  end
  
  context "create action" do
    should "render new template when model is invalid" do
      Journal.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end
    
    should "redirect when model is valid" do
      Journal.any_instance.stubs(:valid?).returns(true)
      post :create
      assert_redirected_to journals_url
    end
  end
  
  context "edit action" do
    should "render edit template" do
      get :edit, :id => Journal.first
      assert_template 'edit'
    end
  end
  
  context "update action" do
    should "render edit template when model is invalid" do
      Journal.any_instance.stubs(:valid?).returns(false)
      put :update, :id => Journal.first
      assert_template 'edit'
    end
  
    should "redirect when model is valid" do
      Journal.any_instance.stubs(:valid?).returns(true)
      put :update, :id => Journal.first
      assert_redirected_to journals_url
      #assert_redirected_to journal_url(assigns(:journal))
    end
  end
  
  context "delete action" do 
    should "render delete template" do
      get :delete, :id => Journal.first
      assert_template 'delete'
    end
  end
  
  context "destroy action" do
    should "not destroy and redirect to index action when there are associated papers" do
      journal = Journal.first
      paper = Paper.make(:journal=>journal)
      journal.reload
      delete :destroy, :id=>journal
      assert_redirected_to journals_url
      assert Journal.exists?(journal.id)
    end
    
    should "destroy model and redirect to index action where there are no papers" do
      journal = Journal.first
      delete :destroy, :id => journal
      assert_redirected_to journals_url
      assert !Journal.exists?(journal.id)
    end
  
  end
end
