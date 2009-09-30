class Public::PublicController < ApplicationController
  #layout 'public'
  access_control do
    allow all
  end
  
end
