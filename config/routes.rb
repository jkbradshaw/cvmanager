ActionController::Routing::Routes.draw do |map|
  
  map.resources :cv, :singular=> :cv_instance do |c|
    c.resource :coauthors, :name_prefix => 'cv_', :only=>[:show, :edit, :update]
    c.resources :papers, :as=> 'articles', :new => {:new => :any, :preview => :post }, :name_prefix => 'cv_', :member => { :delete => :get}, :collection=>{ :journal_list => :get } 
    c.resources :books, :name_prefix => 'cv_', :member => { :delete => :get } 
    c.resources :authors, :name_prefix => 'cv_', :except => [:add, :edit, :create, :new], :member => {:unassociate => :get, :associate=>:get, :ignore=>:get, :remove=>:post}
    c.resources :education, :singular=> :education_instance, :name_prefix => 'cv_', :member => { :delete => :get } 
    c.resources :training, :singular=> :training_instance, :name_prefix => 'cv_', :member => { :delete => :get } 
    c.resources :awards, :name_prefix => 'cv_', :member => {:delete => :get}
    c.resources :certifications, :name_prefix => 'cv_', :member => {:delete => :get}
    c.resource :address, :name_prefix => 'cv_', :member=>{:delete=>:get}
    c.resources :employment, :singular=> :employment_instance, :name_prefix=>'cv_', :member=> {:delete => :get}
    c.resources :presentations, :name_prefix=>'cv_', :member=>{:delete=>:get}
    c.resources :grants, :name_prefix=>'cv_', :member=>{:delete=>:get}
    c.resources :patents, :name_prefix=>'cv_', :member=>{:delete=>:get}
  end
  
  map.journal_list 'journal_list', :controller => 'journal_list', :action => 'search'
  
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
