include TranslateHelper
include ProductsHelper

class CatalogController < ApplicationController
  layout "main"

  def index
    if @language == "ru"
      @page = Page.find_by_name("Русская версия")
    else
      @page = Page.find_by_name("Английская версия")      
    end
  end
  
  def get_sort
    "price DESC"  
  end
  
  helper_method :get_sort
  
  def search
    @page_title = "Поиск по сайту"
    if @language == "ru"
      @way = [["Поиск по сайту", "#"]]
    else
      @way = [["Search", "#"]]
    end
    SearchWord.inc(params[:q], @language)
  end

  def set_currency
    if (!params[:id].blank?) && (["usd","rub"].include?(params[:id]))
      session[:currency] = params[:id]
    end
    if !params[:back].blank?
      redirect_to params[:back]
    end
  end
  
  
  def filter
    #filter_page(page, filter_ids, per_page = 50, order = 'id DESC')
    @filters = []
    if !params[:filter].blank?
      for filter in params[:filter]
        @filters << filter.to_i
      end
    end
    if @filters.blank?
      @way = []
    else
      filters = F.find(:all, :conditions => ["id IN (#{@filters.join(',')})"])
      if filters.blank?
        @way = []
      else
        @page_title = ""
        @f = filters.first
        if @language == "en"
          @page_title = filters.first.title_en
        else
          @page_title = filters.first.title
        end

        @way = [[filters.map{|i| translate_name(i.value)}.join(','), "/catalog/filter?" + filters.map{|i| "filter[]=#{i.id}"}.join('&')]]
      end
    end
    if !params[:price].blank?
      pv = number_with_delimiter(params[:price].to_i, {:delimiter => '&nbsp;'})
      if @language == "en"
        name = "under #{pv}"
      else
        name = "до #{pv}"
      end
      p = params[:price].to_f.round(2).to_s.gsub("\.0$", "")
      #Переводим в баксы
      if !session[:currency].blank? && session[:currency]=="rub"
       # params[:price] = params[:price].to_f / Option.get("kurs_usd").to_f
        name = "#{name} руб."
      else
        name = "#{name} $"
      end
      @way = [[name, "/catalog/filter?price=#{p}"]]
    end
  end
  
  def category
    @category = Category.find_by_id(params[:id])
    if @category.blank?
      redirect_to "/"
    else
      if @language == "ru"
        @page_title = @category.title
      else
        @page_title = @category.title_en
      end
      @way = @category.full_path(@language)
    end
  end
  
  def product
    @product = Product.find_by_id(params[:id])
    if @product.blank?
      redirect_to "/"
    else
      if @language == "ru"
   #     @page_title = @product.name
        @page_title = @product.title
    
    @way = @product.categories.map{|i| [i.name, "/catalog/category/#{i.id}"]} + [[@product.name, "/catalog/product/#{@product.id}"]]      
      else
#        @page_title = @product.name_en
        @page_title = @product.title_en
 
       @way = @product.categories.map{|i| [i.name_en, "/catalog/category/#{i.id}"]} + [[@product.name_en, "/catalog/product/#{@product.id}"]]      
      end  
    end
  end
end
