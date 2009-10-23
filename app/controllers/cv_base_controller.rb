class CvBaseController < ApplicationController
  layout 'cv'
  
  before_filter :find_cv
  before_filter :set_section
  before_filter :load_section, :only=>[:show,:edit,:update,:delete,:destroy]
  before_filter :set_context
  before_filter :check_for_cancel

  access_control do
    allow :admin
    allow :owner, :manager, :of=>:cv
  end
  
  def index
    @columns = @section_class.column_names
    %w[start_date end_date year date_received member_since].each do |y|
      if @columns.include?(y)
        @order = "#{y} DESC"
      end
    end
    @all = defined?(@order) ? @cv.send(@section_name).find(:all, :order=>@order) : @cv.send(@section_name).all
    render :template => 'cv_base/index'
  end
  
  def new
    @one = @cv.send(@section_name).new
    render :template => 'cv_base/new'
  end
  
  def show
  end
  
  def create
    @one = @cv.send(@section_name).new(params[@section_name.singularize.to_sym])
    if @one.save
      flash[:notice] = "Successfully added new #{@section_name.singularize.humanize}"
      redirect_to :action=>'index'
    else
      flash[:error] = "Problem creating"
      render :action=>'new'
    end
  end
  
  def edit
    render :template => 'cv_base/new'
  end
  
  def update
    if @one.update_attributes(params[@section_name.singularize.to_sym])
      flash[:notice] = "Successflly updated"
      redirect_to :action=>'index'
    else
      flash[:error] = "Problem updating"
      render :action=>'edit'
    end
  end
  
  def delete
    render :template => 'cv_base/delete'
  end
  
  def destroy
    if @one.destroy
      flash[:notice] = "Successfully removed"
    else
      flash[:error] = "Problem removing"
    end
    redirect_to :action=>'index'
  end
  
  private
    def find_cv
      @cv = Cv.find(params[:cv_instance_id]) if params[:cv_instance_id]
    end
    
    def set_section
      @base = self.class.to_s.gsub(/Controller$/,'')
      @section_class = @base.singularize.constantize
      @section_name = @base.underscore
      @section_controller = @section_name
    end
    
    def load_section
      @one = @cv.send(@section_name).find(params[:id])
    end
    
    def set_context
      set_user_context(@cv.user)
    end
    
    def check_for_cancel
      redirect_to :action=>'index' if params[:cancel]
    end
    
end