include AdminCategoriesHelper


class AdminCategoriesController < ApplicationController
  layout "admin"
  cache_sweeper :category_sweeper#, :only => [:set_parent, :sort, :delete, :new, :]

  helper_method :model_title

  
  
  def model_title
    {:many => "категории", :one => "категория", :what => "категорию", :list => "категорий"}
  end


  def model_name
    Category
  end
  
  #Установка родителя
  def set_parent
    mn = model_name
    render :update do |page|
      @page = mn.find_by_id(params[:id])
      if !@page.blank?
        if (@page.in_childs(params[:new_parent]))||(params[:id] == params[:new_parent])
          flash[:error] = "Родителя нельзя переносить в потомка."
          page << "document.location='/#{params[:controller]}/list';"
        else
          @page.category_id = params[:new_parent]
          if @page.save
            page << "$('#dragdrop_table_messages>div:first-child').remove();"
          else
            flash[:error] = "Не удалось обновить родителя."
            page << "document.location='/#{params[:controller]}/list';"
          end
        end
      else
        flash[:error] = "Категория не найдена."
        page << "document.location='/#{params[:controller]}/list';"
      end
    end
  end
  
  #Сортировка страниц
  def sort
    i = 1
    for id in params[:sortable_list]
      item = model_name.find_by_id(id)
      if !item.blank?
        item.p = i
        item.save
      end
      i = i + 1
    end
#    render :text => ""
    mn = model_name
    render :update do |page|
      page << "$('#sortable_messages>div:first-child').remove();"
      page.replace_html("page_tree_childs_#{params[:id]}", categories_draggable_tree(mn.find(:all, :conditions => ["category_id = ?", params[:id]], :order => "p"), false))
      page << 'init_dragdrop_tree()'
      page << "$('.fancybox').fancybox({'hideOnContentClick': false})"
      page << "init_delete_page()"
    end
  end
  
  
  #Форма сортировки
  def show_sorter
    @items = model_name.find(:all, :conditions => ["category_id = ?", params[:id]], :order => "p")
    render :layout => false  
  end

  #Удаление
  def delete
    item = model_name.find_by_id(params[:id]) 
    render :update do |page|
      if !item.blank?
        item.destroy
        page << "$('#page_tree_item_#{item.id}').remove();"
      else
        page << "alert(\"Can't find item.\")"  
      end
    end
  end
  
  def list
    @page_title = "Список #{model_title[:one]}"
    @items = model_name.find(:all, :conditions => ["category_id = 0"], :order => "p")
  end

  def new
    @page_title = "Добавить #{model_title[:what]}"

    @item = model_name.new
    if request.post?
      @item = model_name.new(params[:item])
      if @item.save       
        flash[:notice] = "#{model_title[:one]} добавлена."
        #redirect_to "/admin_pages/edit/" + @item.id.to_s
        redirect_to "/#{params[:controller]}/list"
      end
    end
  end

  # GET /news/1/edit
  def edit
    @page_title = "Редактировать #{model_title[:what]}"
    
    @item = model_name.find(params[:id])
    if @item.blank?
      flash[:error] = "Запись не найдена."
      redirect_to "/#{params[:controller]}/list"
    else
      if request.post?
        if @item.in_childs(params[:item][:page_id])
          flash[:error] = "Родителя нельзя переносить в потомка."
          redirect_to "/#{params[:controller]}/edit/#{@item.id}"
        elsif @item.update_attributes(params[:item])     
          flash[:notice] = "#{model_title[:one]} отредактирована."
          redirect_to "/#{params[:controller]}/edit/#{@item.id}"
        end
      end
    end
  end

  def destroy
    @item = model_name.find(params[:id])
    @item.destroy
  end



end
