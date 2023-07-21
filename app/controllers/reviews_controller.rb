class ReviewsController < ApplicationController
  layout "main"

  def index
    @page_title = translate "users_reviews"
    @page = Page.find_by_system_name("reviews_#{@language}")
    @page_title = @page.title
      @links_titles = @page.links_titles.to_s.split("\n")      
      @links_urls = @page.links_urls.to_s.split("\n")      
    @items = Review.find(:all, :order => "created_at", :conditions => ["moderated = 1 AND language = ?", @language])
  end
  
  def new
    @page_title = translate "reviews_new"
    @page = Page.find_by_system_name("reviews_#{@language}")
    @page_title = @page.title
      @links_titles = @page.links_titles.to_s.split("\n")      
      @links_urls = @page.links_urls.to_s.split("\n")      
    @item = Review.new
    if !current_user.blank?
      @item.name = "#{current_user.firstname} #{current_user.lastname}".strip
    end
    if request.post?
      @item = Review.new(params[:item])
      @item.moderated = false
      @item.language = @language
      if @item.save
        flash[:notice] = translate "review_add_complete"
        redirect_to "/reviews/index"
      end
    end
  end
end
