class Admin::AdminController < ApplicationController
  before_filter :clear_user_context
  layout 'admin'
  
  access_control do
    allow :admin
  end
  

  
end
