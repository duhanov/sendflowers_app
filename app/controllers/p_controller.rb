class PController < ApplicationController
  layout "main"
  
  def index
    @links_titles = []
    @links_urls = []
    if params[:id] == "index"
      @page = Page.find_by_system_name("index")    
      render :layout => "index"
    else
      @page = Page.find_by_url(params[:id])    
    end
    if @page.blank?
      @page_title = "Не найдено"
    else
      @page_title = @page.title
      
      @links_titles = @page.links_titles.to_s.split("\n")      
      @links_urls = @page.links_urls.to_s.split("\n")      
    end
      
  end
end
