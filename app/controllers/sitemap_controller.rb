#include ProductsHelper
#include ArticlesHelper
include CatalogHelper
include NewsHelper

class SitemapController < ApplicationController
   layout "main"
   
  def view
    @page_title = translate("sitemap")
  end
    
  def robots
    response.headers["Content-Type"] = 'text/plain'
    if @language.blank? || @language == "ru"
      render :text => Option.get("robots")
    else
      render :text => Option.get("robots_en")      
    end
  end
  
  def sitemap_url(xml ,loc, lastmod)
      xml.url {
        xml.loc(loc)
        if lastmod.to_s != ""
          xml.lastmod(lastmod.strftime("%Y-%m-%d"))
        end
        #xml.changefreq("daily")
        #xml.priority(1)
      }    
  end
  
  
  def products(xml, cat)
    for product in Product.find(:all, :conditions => ["active = 1"], :joins => "INNER JOIN categories_products ON (products.id = categories_products.product_id AND categories_products.category_id = #{cat.id})")  
      sitemap_url(xml, full_url(link2product(product)), product.updated_at)
    end
  end
  


 # def articles(xml)
 #   for article in Article.find(:all)
 #     sitemap_url(xml, full_url(link2article(article)), article.updated_at)
 #   end    
#  end
  
  def full_url(url)
    @domain = request.domain.downcase
    "https://#{@domain}#{url}"  
  end
  
  def categories(xml, cats = [])
    if cats == []
      cats = Category.find(:all, :conditions => ["category_id = 0"], :order => "p")     
    end
    
    for cat in cats
      sitemap_url(xml, full_url(link2category(cat)), cat.updated_at)
      if cat.categories == []
        products(xml, cat)
      else
        categories(xml, cat.categories)
      end
    end
  end
  
  def news(xml)
    @news = News.find(:all, :conditions => ["language = ?", @language], :order => "created_at DESC")
    if !@news.blank?
      sitemap_url(xml, full_url("/news"), @news.first.updated_at)
      for news in @news
        sitemap_url(xml, full_url(link2news(news)), news.updated_at)        
      end
    end
  end

  def pages_links(ps = "", level = 0)
    res = []
    if ps == ""
      ps = []
      if @language == "ru"
        p = Page.find(:first, :conditions => ["name = ?", "Русская версия"])
      else
        p = Page.find(:first, :conditions => ["name = ?", "Английская версия"])        
      end
      if !p.blank?
        ps = p.pages
      end
    end
    
    for item in ps
      url = full_url("/p/#{item.url}")
      res << "<a style='display: block; margin-left: #{(level*5)}px' href='#{url}'>#{item.name}</a>"
      if !item.pages.blank?
        res = res + pages_links(item.pages, level + 1)
      end
    end      
    res 
  end
  
  def categories_links(ps = "", level = 0)
    res = []
    if ps == ""
      ps = Category.find(:all, :conditions => ["category_id = 0"])
    end
    
    for item in ps
      url = full_url("/catalog/category/#{item.id}")
      if @language == "en"
        name = item.name_en
      else
        name = item.name      
      end
      
      res << "<a style='display: block; margin-left: #{(level*5)}px' href='#{url}'>#{name}</a>"
      if !item.categories.blank?
        res = res + categories_links(item.categories, level + 1)
      end
    end      
    res 
  end  
  
  helper_method :pages_links
  helper_method :categories_links
  
  def pages(xml, ps = "")
    if ps == ""
      ps = []
      if @language == "ru"
        p = Page.find(:first, :conditions => ["name = ?", "Русская версия"])
      else
        p = Page.find(:first, :conditions => ["name = ?", "Английская версия"])        
      end
      if !p.blank?
        ps = p.pages
      end
    end
    
    for item in ps
      sitemap_url(xml, full_url("/p/#{item.url}"), item.updated_at)
      if !item.pages.blank?
        pages(item.pages)
      end
    end  
  end

  def reviews(xml)
    items = Review.find(:all, :conditions => ["language = ?", @language], :order => "created_at DESC")
    if !items.blank?
      sitemap_url(xml, full_url("/reviews/index"), items.first.updated_at)
    end
  end
  
  
  def holidays(xml)
    for i in 1..12
      sitemap_url(xml, full_url("/holidays/month/#{i}"), DateTime.now)
    end
  end
  
  def generate_sitemap
    @domain = request.domain.downcase
    xml = Builder::XmlMarkup.new(:indent => 1)
    xml.instruct! :xml, :version => "1.0", :encoding=>"UTF-8"
    xml.urlset(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9"){
      #Главная
      xml.url {
        xml.loc("http://#{@domain}/")
        lastmod = Time.now.strftime("%Y-%m-%d")
        xml.lastmod(lastmod)
        xml.changefreq("daily")
        xml.priority(1)
      }
      #Новости
      news(xml)
      #Reviews
      reviews(xml)
      #Цикл по категориям
      categories(xml)
      #
      holidays(xml)
      #
      pages(xml)
      #Статьи
      #articles(xml)
    }    
  end
  
  def index
#xml.urlset(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9") {
  # Index
#  xml.url {
 #   xml.loc('http://test')
  #  lastmod = Time.now.strftime("%Y-%m-%d")
   # xml.lastmod(lastmod)
    #xml.changefreq("daily")
    #xml.priority(1)
 # }
#}
    respond_to do |format|
      format.xml {render :xml => generate_sitemap}
    end    
  end
end
