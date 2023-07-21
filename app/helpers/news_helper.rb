module NewsHelper
  
  def news_date(news)
    if @language == "ru"
      return Russian::strftime(news.created_at, "%d %B %Y года")
    else
      return news.created_at.strftime("%d %B %Y")      
    end
  end
  
  def link2news(news)
    "/news/#{news.created_at.strftime('%Y/%m/%d')}/#{news.url}"
  end
end