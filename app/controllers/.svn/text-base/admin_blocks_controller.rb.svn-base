include BlockHelper

class AdminBlocksController < ApplicationController
  layout "admin"
  

  
  def menu_items_sort
    block = Block.find_by_id(params[:id])
    debug = ""
    if block.blank?
      debug = "block blank"
    else      
      menu_items = []
      for item in params[:menu_items]
        if  /^[0-9]+(.+)([0-9])+$/ =~ item
          debug = debug + "#$1 #$2 ; "
          menu_items << {:type => "#$1", :page_id => "#$2" }
        end
      end
      block.body = Marshal.dump(menu_items)
      block.save
    end
    render :text => debug  
  end
  
  def add2menu
    @item = Block.find_by_id(params[:id])  
    if @item.blank?
    else
      @menu_items = get_block_menu(@item)
      @menu_items << params[:menuitem]
      @item.body = Marshal.dump(@menu_items)
      @item.save
    end
    @blocks = Block.find(:all, :conditions => ["t = ?", params[:id]], :order => 'p') 
    render :file => "app/views/admin_blocks/_menu_items.html.erb"
  end
  
  def edit_menu
    @menu_items = []
    @item = Block.find_by_id(params[:id])
    @menu_items = get_block_menu(@item)
    
    if !params[:ajax].blank?
      render :layout => false
    end         
  end

  def update_block
    @item = Block.find_by_id(params[:id])
    if !@item.blank?
      @item.update_attributes(params[:item])
      respond_to_parent do
        render :update do |page|
          if @item.content_type == "banner"
            page << "ajaxEditForm(\"/admin_blocks/edit_banner/#{@item.id}?ajax=true\", \"Редактирование баннера\")"
          else
            page << "$.fn.fancybox.close();"
          end  
        end
      end
    end
  #  render :text => ""
  end
  
  def edit_banner
    @item = Block.find_by_id(params[:id])
    if !params[:ajax].blank?
      render :layout => false
    end      
  end


  def edit_last_articles
    @item = Block.find_by_id(params[:id])
    if @item.body.to_s == ""
      @item.body = "5"
      @item.save
    end
    render :layout => false
  end
  
  def edit_text
    @item = Block.find_by_id(params[:id])
    if request.post?
      @item.update_attributes(params[:item])
#      @blocks = Block.find(:all, :conditions => ["t = ?", @blocks_t], :order => "p") 
      respond_to_parent do
        render :update do |page|
 #           page.replace_html "items#{blocks.t}", :render_partial => "admin_blocks/_blocks_list"
          page << "$.fn.fancybox.close();"
        end
      end
    else
      if !params[:ajax].blank?
        render :layout => false
      end      
    end    
  end
  
  def remove
    block = Block.find(:first, :conditions => ["id = ? AND t > 0", params[:id]])
    if !block.blank?
      block.destroy
    end
    render :text => "Deleted"
  end
  
  def add_block
    block = Block.new
    block.t = params[:id]
    if !params[:name].blank?
      block.name = params[:name]  
    end
    block.content_type = params[:content_type]
    block.runame = get_block_title(block)
    block.save
    @blocks = Block.find(:all, :conditions => ["t = ?", params[:id]], :order => 'p') 
    render :file => "app/views/admin_blocks/_blocks_list.html.erb"
  end
  
  def update_positions
    #params[:sortable_list].each_index do |i|
    #  item = Block.find(params[:sortable_list][i])
    #  item.p = i
    #  item.save
    #end
    i = 1
    index = "sortable_list"# + params[:id].to_s
    for id in params[index]
      item = Block.find(id)
      if !item.blank?
        item.p = i
        item.save      
      end
      i = i + 1
    end
    @blocks = Block.find(:all, :conditions => ["t = ?", params[:id]], :order => 'p') 
    render :file => "app/views/admin_blocks/_blocks_list.html.erb"
   # render :layout => false, :action => :list
  end

  
  #Список
  def list
    if params[:language].blank?
      params[:language] = "ru"
    end
    #Получаем записи
    @ddir_type = "bloks"
    @page_title = "Список блоков"
    @add_or_edit_btn_title = "Добавить"
    @add_or_edit_btn = "new"
    @active_btn = "list"        
    @blocks = Block.find(:all, :conditions => ["p >= 0 AND language = ?", params[:language]], :order => "p")
  end


  def edit
    @ddir_type = "blocks"
    @page_title = "Редактирование блока"
    @add_or_edit_btn_title = "Редактировать"
    @add_or_edit_btn = "edit"
    @active_btn = "new"    
    
    if !request.post?
      @block = Block.find(params[:id])
    else
      @block = Block.find(:first, :conditions => ["id = ?", params[:block][:id]])
      if @block.update_attributes(params[:block])     
        flash[:notice] = 'Блок отредактирован.'
        redirect_to "/admin_blocks/edit/" + @block.id.to_s        
      end
    end
  end

end
