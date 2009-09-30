# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time
  helper :layout
  helper_method :current_user, :user_context
  
  rescue_from Acl9::AccessDenied, :with=>:access_denied
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  def set_user_context (user)
    session[:user_context] = user.id
  end
  
  def user_context
    return false unless current_user
    session[:user_context] ||= current_user.id
    return User.exists?(session[:user_context]) ? User.find(session[:user_context]) : false
  end
  
  def reset_user_context
    session[:user_context] = current_user ?  current_user.id : nil
  end
  
  def clear_user_context
    session[:user_context] = nil
  end

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
    
    def access_denied
      flash[:error] = 'Whoa tiger -- you don\'t have access to that page'
      redirect_to root_url
    end

end
