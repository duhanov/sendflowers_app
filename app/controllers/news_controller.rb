class NewsController < ApplicationController
  layout "main"
  
  def show
    @item = News.find_by_url(params[:id])  
    if @item.blank?
      redirect_to "/404.html"
    else
      @page_title = @item.title
    end
  end
  
  def index
    #@page = Page.find_by_system_name("news")  
    @page_title = translate("news_title")#@page.title
    @items = News.items_page(params[:page], ["language = ?", @language], 100, "created_at DESC")
  end
end
