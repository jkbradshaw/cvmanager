class CmesController < ApplicationController
  before_filter :set_context
  before_filter :check_for_cancel
  
  layout 'cme'

  def index
    @cmes = @owner.cmes.find(:all)
  end
  
  def new
    @cme = @owner.cmes.new
    #@categories = CmeCategory.find(:all, :order => "category").map {|u| [u.category, u.id] }
    #@categories = @categories.sort {|a,b| a[0].downcase <=> b[0].downcase}
    @cme_categories = :cme_category_attributes
  end
  
  def create
    @cme = @owner.cmes.new(params[:cme])
    if @cme.save
      flash[:notice] = "Successfully created"
      redirect_to cmes_path
    else
      flash[:error] = "Problems creating"
      render 'new'
    end
  end
  
  def edit
    @cme = @owner.cmes.find(params[:id])
    @cme_categories = :cme_category
    #@categories = CmeCategory.find(:all, :order => "category").map {|u| [u.category, u.id] }
    #@categories = @categories.sort {|a,b| a[0].downcase <=> b[0].downcase}
  end
  
  def update
    @cme = @owner.cmes.find(params[:id])
    if @cme.update_attributes(params[:id])
      flash[:notice] = "Successfully updated"
      redirect_to cmes_path
    else
      flash[:error] = "Problems updating"
      render 'edit'
    end
  end
  
  def delete
    @cme = @owner.cmes.find(params[:id])
  end
  
  def destroy
    @cme = @owner.cmes.find(params[:id])
    if @cme.destroy
      flash[:notice] = "Successfully removed"
      redirect_to cmes_path
    else
      flash[:error] = "Problems removing from datatbase"
      redirect_to cmes_path
    end
  end

  private
    def set_context
      if user_context
        @owner = user_context
      else
        flash[:notice] = 'Please log in'
        redirect_to root_url
      end
    end
    
    def check_for_cancel
      redirect_to cmes_path if params[:cancel]
    end

end