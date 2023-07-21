module DeliveryPhotosHelper
  def photo_date(news)
    if @language == "ru"
      return Russian::strftime(news.created_at, "%d %B")
    else
      return news.created_at.strftime("%d %B")   
    end  
  end
end
