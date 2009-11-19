ActionController::Routing::Routes.draw do |map|
  
  map.resources :cv, :singular=> :cv_instance do |c|
    c.resource :coauthors, :name_prefix => 'cv_', :only=>[:show, :edit, :update]
    c.resource :address, :name_prefix => 'cv_', :member=>{:delete=>:get, :valid=>:post}
    c.resources :authors, :name_prefix => 'cv_', :except => [:add, :edit, :create, :new], :member => {:unassociate => :get, :associate=>:get, :ignore=>:get, :remove=>:post}, :collection=>{:search=>:get}
    c.resources :papers, :as=> 'articles', :new => {:new => :any, :preview => :post }, :name_prefix => 'cv_', :member => { :delete => :get}, :collection=>{ :journal_list => :get} 
    c.resources :education, :singular=> :education_instance, :name_prefix => 'cv_', :member => { :delete => :get }
    c.resources :training, :singular=> :training_instance, :name_prefix => 'cv_', :member => { :delete => :get } 
    c.resources :employment, :singular=> :employment_instance, :name_prefix=>'cv_', :member=> {:delete => :get}   
    [:books, :awards, :certifications, :presentations, :grants, :patents, :memberships, :faculty_appointments, :clinical_activities, :admin_positions, :national_positions].each do |x|
      c.resources x, :name_prefix => 'cv_', :member => {:delete => :get}
    end
    c.activities 'activities', :name_prefix=> 'cv_', :controller=>'activities', :action=>'index'
  end
  
  map.journal_list 'journal_list', :controller => 'journal_list', :action => 'search'
  map.cme_category_list 'cme_categories_list', :controller => 'cme_categories_list', :action => 'search'
  
  map.resource :user, :except=>:index do |user|
    user.resources :managers, :name_prefix=> 'cv_', :collection=>{:search=>:get}, :except=>[:show,:edit,:update], :member => {:delete=>:get}
  end
  
  map.resources :cmes, :member => { :delete => :get }
  
  map.arvu 'arvu', :controller=> 'arvu', :action=>'show'
  
  map.namespace :admin do |a|
    a.root :controller=>'admin', :action=>'index'
    a.resources :sections, :member=>{:delete=>:get}
    a.resources :journals, :member=>{:delete=>:get}
    a.resources :faculty, :singular=> :faculty_instance, :member=>{:delete=>:get}, :except=>[:new,:create]
    a.resources :cme_categories, :member=>{:delete=>:get}
    a.resources :users, :member=>{:delete=>:get, :permissions=>:get, :update_permissions=>:post} do |f|
      f.resource :faculty, :only=>[:new,:create]
    end
  end
  
  map.namespace :public do |p|
    p.cv 'cv/:name', :controller=>'cv', :action=>'public_cv'
    p.summary 'cv/', :controller=>'cv', :action=>'summary'
  end

  map.login "login", :controller=>'user_sessions', :action=>'new'
  map.logout "logout", :controller=>'user_sessions', :action=>'destroy'
  
  map.resources :user_sessions
  
  map.root :controller=>'public/cv', :action=>'summary'
  

end
