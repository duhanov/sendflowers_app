include AdminPagesHelper

class AdminPagesController < ApplicationController
  layout "admin"

  def update_pages_tree
    render :update do |page|
      @items = Page.find(:all, :conditions => ["page_id = 0"], :order => "p")
      page.replace_html('pages_tree', pages_draggable_tree(@items))
      page << "alert('Страницы испортированы!');"
    end
  end

  #Экспорт в формате JSON
  def export_download_json(page_id)
    res = []
    for page in Page.find(:all, :conditions => ["page_id = ?", page_id], :order => "p")
      res << {:url => page.url, :name => page.name, :title => page.title, :meta_keywords => page.meta_keywords, :meta_description => page.meta_description, :body => page.body, :desc => page.desc, :p => page.p, :is_system => 0, :system_name  => "", :show_in_menu => page.show_in_menu, :language => page.language, :links_urls => page.links_urls, :links_titles => page.links_titles, :show_reviews => page.show_reviews, :show_photos => page.show_photos, :pages => export_download_json(page.id)}
    end
  end
  
  def export_or_download(id)
    if params[:download].blank?
      render :layout => false
    else
      response.headers['Content-Disposition'] = "attachment; filename=#{@title.gsub(/\s/,'_')}.json"
      #ActiveSupport::JSON.decode(
      render :text => export_download_json(id).to_json
    end
  end

  def export
    @page = Page.find_by_id(params[:id])
    if params[:id] == "0"
      @title = "Экспорт корневого раздела"
      export_or_download(params[:id]) 
    elsif !@page.blank?
      @title = "Экспорт страниц раздела #{@page.title}"
      export_or_download(params[:id])
    else
      render :text => "Раздел не найден."
    end
  end

  def import_json_items(page_id, items)
    log = ""
    #page = Page.find_by_id(page_id)
    #if !page.blank?
      for item in items
        childs = item[:pages]
        item["page"].delete(:pages)
        log << "item: " + item.inspect
        p = Page.new(item["page"])
        p.page_id = page_id
        if p.save && !childs.blank?
          log << import_json_items(p.id, childs)
        end
      end
    #end
    log
  end

  def import_json
    @page = Page.find_by_id(params[:id])
    if params[:id] == "0" || !@page.blank?
      data = request.env['rack.input'].read
      data = JSON.parse(data)#ActiveSupport::JSON.decode(data)
      #render :text => data.inspect 
    #  import_json_items(params[:id], data)
     # render :text => "{success: true}"
      render :text => import_json_items(params[:id], data)
    else
      #render :text => "Раздел не найден."
      render :text => "{success: false}"
    end
  end

  def import
    @page = Page.find_by_id(params[:id])
    if params[:id] == "0"
      @title = "Импорт страниц в корневой раздел"
      render :layout => false
    elsif !@page.blank?
      @title = "Импорт страниц в раздела #{@page.title}"
      render :layout => false
    else
      render :text => "Раздел не найден."
    end
  end



  def update_page_content
    if request.post?
      @item = PageContent.find_by_id(params[:id])
      if !@item.blank?
        if @item.update_attributes(params[:page_content])
        
        end
      end
      if !params[:back].blank?
        redirect_to params[:back]
      else
        flash[:notice] = "Текст отредактирован"
        redirect_to "/admin_pages/update_page_content/#{@item.id}"
      end
    else
      @page_content = PageContent.find_by_id(params[:id])
      if @page_content.blank?
        render :text => "Текст не найден."
      else
        render :layout => false
      end
    end
  end
  

  #Установка родителя
  def set_parent
    render :update do |page|
      @page = Page.find_by_id(params[:id])
      if !@page.blank?
        if (@page.in_childs(params[:new_parent]))||(params[:id] == params[:new_parent])
          flash[:error] = "Родителя нельзя переносить в потомка."
          page << 'document.location="/admin_pages/list";'
        else
          @page.page_id = params[:new_parent]
          if @page.save
            page << "$('#dragdrop_table_messages>div:first-child').remove();"
          else
            flash[:error] = "Не удалось обновить родителя."
            page << 'document.location="/admin_pages/list";'
          end
        end
      else
        flash[:error] = "Страница не найдена."
        page << 'document.location="/admin_pages/list";'
      end
    end
  end
  
  #Сортировка страниц
  def sort
    i = 1
    for id in params[:sortable_list]
      item = Page.find_by_id(id)
      if !item.blank?
        item.p = i
        item.save
      end
      i = i + 1
    end
#    render :text => ""
    render :update do |page|
      page << "$('#sortable_messages>div:first-child').remove();"
      page.replace_html("page_tree_childs_#{params[:id]}", pages_draggable_tree(Page.find(:all, :conditions => ["page_id = ?", params[:id]], :order => "p"), false))
      page << 'init_dragdrop_tree()'
      page << "$('.fancybox').fancybox({'hideOnContentClick': false})"
      page << "init_delete_page()"
    end
  end
  
  
  #Форма сортировки
  def show_sorter
    @items = Page.find(:all, :conditions => ["page_id = ?", params[:id]], :order => "p")
    render :layout => false  
  end

  #Удаление
  def delete
    render :update do |page|
      item = Page.find_by_id(params[:id]) 
      if !item.blank?
        item.destroy
        page << "$('#page_tree_item_#{item.id}').remove();"
      else
        page << "alert(\"Can't find item.\")"  
      end
    end
  end
  
  def list
    @page_title = "Список страниц"
    @items = Page.find(:all, :conditions => ["page_id = 0"], :order => "p")
  end

  def new
    @ddir_type = "pages"
    @page_title = "Добавление страницы"
    @add_or_edit_btn_title = "Добавить"
    @add_or_edit_btn = "new"
    @active_btn = "new"    

    @item = Page.new
    if request.post?
      @item = Page.new(params[:item])
      if @item.save       
        flash[:notice] = 'Страница добавлена.'
        #redirect_to "/admin_pages/edit/" + @item.id.to_s
        redirect_to "/admin_pages/list"
      end
    end
  end

  # GET /news/1/edit
  def edit
    @ddir_type = "pages"
    @page_title = "Редактирование страницы"
    @add_or_edit_btn_title = "Редактировать"
    @add_or_edit_btn = "edit"
    @active_btn = "new"    
    
    if !request.post?
      @item = Page.find(params[:id])
    else
      @item = Page.find(:first, :conditions => ["id = ?", params[:item][:id]])
      if @item.in_childs(params[:item][:page_id])
          flash[:error] = "Родителя нельзя переносить в потомка."
          redirect_to "/admin_pages/edit/#{@item.id}"
       else
        if @item.update_attributes(params[:item])     
          flash[:notice] = 'Страница отредактирована.'
          redirect_to "/admin_pages/edit/#{@item.id}"
        end
      end
    end
  end

  def destroy
    @item = Page.find(params[:id])
    @item.destroy
  end
end
