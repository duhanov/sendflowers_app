class AdminDeliveryPhotosController < ApplicationController
  layout "admin"
  
  include Admin
  
  before_filter :init_tabs
  
  def model_title
    {:one => "фотография доставки",:what => "фотографию доставки", :many => "Фотографии доставок"}  
  end
  
  def init_tabs
    @tabs = [["Добавить фото", "/#{params[:controller]}/new"], ["Фотографии доставок", "/#{params[:controller]}/list"]]    
    if params[:action] == "edit"
      @tabs = [["Редактирование фото", "/#{params[:controller]}/edit"]] + @tabs
    end
  end
  

  
  helper_method :model_name
  helper_method :model_title
  
  def model_name
    DeliveryPhoto  
  end
  
  def list
    @page_title = "Фотографии доставок"
    @items = DeliveryPhoto.items_page(params[:page])
    
  end
end
