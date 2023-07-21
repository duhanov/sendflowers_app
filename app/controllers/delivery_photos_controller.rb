class DeliveryPhotosController < ApplicationController
  layout "main"
  def index
    @page_title = "#{translate("delivery_photos_title")} #{params[:year]}"
    @page = Page.find_by_system_name("photos_#{@language}")
      @links_titles = @page.links_titles.to_s.split("\n")      
      @links_urls = @page.links_urls.to_s.split("\n")      

    if params[:year].blank?
      params[:year] = DateTime.now.strftime('%Y')
    end
    params[:year] = params[:year].to_i
    @to_year = DateTime.now.strftime('%Y').to_i
    @from_year = @to_year-4
    
    min = DeliveryPhoto.find(:first, :select => "YEAR(created_at) as year", :order => "created_at ASC")
    if !min.blank?
      @from_year = min.year
    end
    max = DeliveryPhoto.find(:first, :select => "YEAR(created_at) as year", :order => "created_at DESC")
    if !min.blank?
      @to_year = max.year
    end
    
    @items = DeliveryPhoto.items_page(params[:page], ["YEAR(created_at) = ?", params[:year]], 100)
  end

end
