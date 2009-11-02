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
    unless defined? @all
      @columns = @section_class.column_names
      %w[start_date end_date year date_received member_since].each do |y|
        if @columns.include?(y)
          @order = "#{y} DESC"
        end
      end
    
      @all = defined?(@order) ? @cv.send(@section_name).find(:all, :order=>@order) : @cv.send(@section_name).all
    end
    render :template => 'cv_base/index'
  end
  
  def new
    @one = @cv.send(@section_name).new unless defined?(@one)
    render :template => 'cv_base/new'
  end
  
  def show
  end
  
  def create
    @one = @cv.send(@section_name).new(params[@section_name.singularize.to_sym]) unless defined? @one
    respond_to do |format|
      format.html do
        if @one.save
          flash[:notice] = "Successfully added new #{@section_name.singularize.humanize}"
          redirect_to :action=>'index'
        else
          flash[:error] = "Problem creating"
          render :template=>'cv_base/new'
        end
      end
      format.js do
        if @one.save
          flash[:notice] = "Successfully added new #{@section_name.singularize.humanize}"
          redirect_to :action=>'index'
        else
          @errors = @one.errors.to_a.map {|x| x[0] = [@section_name.singularize.underscore + '_' + x[0],x[1]] }
          render :json => @errors
        end
      end
    end
  end
  
  def edit
    render :template => 'cv_base/edit'
  end
  
  def update
    respond_to do |format|
      format.html do
        if @one.update_attributes(params[@section_name.singularize.to_sym]) 
          flash[:notice] = "Successflly updated"
          redirect_to :action=>'index'
        else
          flash[:error] = "Problem updating"
          render :action=>'edit'
        end
      end
      format.js do
        if @one.update_attributes(params[@section_name.singularize.to_sym]) 
          render :json => {:success=>true }
        else
          render :json => {:errors => @one.errors}
        end
      end
    end
  end
  
  def delete
    render :template => 'cv_base/delete'
  end
  
  def destroy
    respond_to do |format|
      format.html do
        if @one.destroy
          flash[:notice] = "Successfully removed"
        else
          flash[:error] = "Problem removing"
        end
        redirect_to :action=>'index'
      end
      format.js do
        @one.destroy
        render :nothing=>true
      end
    end
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