include ApplicationHelper
class AdminNewsController < ApplicationController
  layout "admin"


  
  before_filter :init_tabs
  
  helper_method :model_title
  
  def model_title
    {:what => "новость", :list => "новостей"}  
  end

  def init_tabs
    @tabs = [["Добавить #{model_title[:what]}", "/#{params[:controller]}/new"], ["Список #{model_title[:list]}", "/#{params[:controller]}/list/"]]  
    if params[:action] == "edit"
      @tabs = [["Редактировать #{model_title[:what]}", "/#{params[:controller]}/edit/#{params[:id]}"]] + @tabs
    end
  end
  
  def update
    @item = News.find_by_id(params[:id])
    if !@item.blank?
      if ["name", "published", "created", "show_on_index"].include?(params[:field])
        if @item.update_attributes({params[:field] => params[:update_value]})
          if ["published", "show_on_index"].include?(params[:field])
            render :text => show_yesno(params[:update_value])
          else
            render :text => params[:update_value]          
          end
        else
          render :text => "Can't update item"
        end
      else
        render :text => "Не известное поле #{params[:field]}"        
      end
    else
      render :text => "Не удалось найти запись"
    end
  end

  def get_sort(default = 'created_at DESC')
    @sort = default
    if (!params[:sort].blank?) 
      @sort = params[:sort]
    end 
    return @sort
  end

  def new
    @page_title = "Создать новость"
    @item = News.new
    if request.post?
      if @item.update_attributes(params[:item])
        flash[:notice] = "Новость создана"
        redirect_to "/admin_news/list"
      end
    end
  end
  
  def edit
    @page_title = "Редактирование новости"
    @item = News.find_by_id(params[:id])
    if @item.blank?
      flash[:error] = "Новость не найдена."
      redirect_to "/admin_news/list"
    else
      if request.post?
        if @item.update_attributes(params[:item])
          flash[:notice] = "Новость отредактирована."
          redirect_to "/admin_news/edit/#{@item.id}"
        end
      end    
    end
  end
  
  def delete
    @item = News.find_by_id(params[:id])
    if !@item.blank?
      @item.destroy
    end
    render :text => ""
  end
  
  def list
    @page_title = "Список новостей"
    @items = News.items_page(params[:page], "", 50, get_sort)
  end
end
