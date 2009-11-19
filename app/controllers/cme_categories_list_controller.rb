class CmeCategoriesListController < ApplicationController
  def search
    render :text=> '' and return unless params[:q]
    @category_list = CmeCategory.category_like(params[:q]).ascend_by_category.all.map{|x| x.category}
    
    respond_to do |format|
      format.html do
        @list = @category_list.join("\n")
        render :text => @list
      end
      format.js do
        @list = @category_list.join("\n")
        render :text => @list
      end
    end
  end
end