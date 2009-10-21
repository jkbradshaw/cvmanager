class JournalListController < ApplicationController
  def search
    render :text=> '' and return unless params[:q]
    @journal_list = Journal.long_title_like(params[:q]).ascend_by_long_title.all.map{|x| x.long_title}
    
    respond_to do |format|
      format.html do
        @list = @journal_list.join("\n")
        render :text => @list
      end
      format.js do
        @list = @journal_list.join("\n")
        render :text => @list
      end
    end
  end
end