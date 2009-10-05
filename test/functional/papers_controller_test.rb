require 'test_helper'

class PapersControllerTest < ActionController::TestCase

  cv = Cv.make
  owner = cv.user
  author = Author.make
  cv.authors << author
  paper = Paper.make
  paper.authors << author
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
    
    context 'no internet connection' do
      should 'raise no internet connection error' do
      end
    end
    
    context 'get index' do
      should 'display index templte' do
        get :index, {:cv_instance_id=>cv}
        assert_template 'index'
      end
    end
    
    context 'get new' do
      should 'display new template' do
        get :new, {:cv_instance_id=>cv}
        assert_template 'new'
      end
    end
    
    context 'preview action' do
      setup do
        @pubmed_data = {}
        @pubmed_data['pmid'] = Sham.pmid+'1'
        @pubmed_data[:journal_volume] = ''
        @pubmed_data[:journal_issue] =''
        @pubmed_data[:journal_year] = Sham.year
        @pubmed_data[:title] = Sham.title
        @pubmed_data[:journal_pages] = Sham.pages
        
        @pubmed_data[:journal] = {}
        @pubmed_data[:journal][:issn] = Sham.issn
        @pubmed_data[:journal][:nlmuid] = Sham.nlmuid
        @pubmed_data[:journal][:short_title] = Sham.title
        @pubmed_data[:journal][:long_title] = Sham.title
        
        @pubmed_data[:authors] = []
        (1..3).each do |i|
          f = Sham.first_name
          l = Sham.last_name
          @pubmed_data[:authors] << {:last_name=>l, :first_name=>f, :author_position=>i}
        end
        
      end
      
      #FIXME: fix the papers preview controller test
      should 'display preview template' do
        params = @pubmed_data
        post :preview, {:cv_instance_id=>cv, :params=>@pubmed_data}
        #assert flash[:error]
        #assert_template 'preview'
      end
    end
    
    context 'delete action' do
      should 'display delete template' do
        get :delete, {:cv_instance_id=>cv, :id=>paper}
        assert_template 'delete'
      end
    end
    
  end
  
  
end