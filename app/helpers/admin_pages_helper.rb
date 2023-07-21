module AdminPagesHelper

  def page_content(name, opts = false)
    opts = {:flybox => false, :textarea => false} if !opts.is_a?(Hash) 
    #Размеры тексареа по умолчанию
    opts[:textarea] = {} if !opts[:textarea].is_a?(Hash) && opts[:textarea]
    if opts[:textarea] && opts[:textarea].is_a?(Hash)
      opts[:textarea][:cols] = 50 if opts[:textarea][:cols].blank?
      opts[:textarea][:rows] = 5 if opts[:textarea][:rows].blank?
    end
    #Текст на ссылках
    params[:add_text_title] = opts[:add_text_title] if !opts[:add_text_title].blank?
    params[:edit_text_title] = opts[:edit_text_title] if !opts[:edit_text_title].blank?
    res = ""
    @page_content = PageContent.find_by_name(name)
    if @page_content.blank?
      @page_content = PageContent.new({:name => name})
      @page_content.save
    end
    render :partial => "widgets_admin/page_content", :locals => {:flybox => opts[:flybox], :opts => opts}
  end


  def page_content_link_title(opts)
    opts[:add_text_title] = "Добавить сюда текст" if opts[:add_text_title].blank?
    opts[:edit_text_title] = "Редактировать этот текст" if opts[:edit_text_title].blank?

    if !params[:edit_page_content].blank?
      return ""
    elsif @page_content.body.to_s.strip == ""
      return opts[:add_text_title]
    else
      return opts[:edit_text_title]
    end
  end
  
  #Ссылки на иморт экспорт разделов
  def pages_draggable_tree_import_export_links(id)
    if !params[:import_export].blank?
      return " / <a href='/admin_pages/import/#{id}' class='fancybox'>Импорт</a> | <a href='/admin_pages/export/#{id}' class='fancybox'>Экспорт</a> /"
    end
  end

  def pages_draggable_tree(items, init = true)
    html = ""
    if init
      html << '<ul class="myTree">'
      html << "<li page_id='0' id='page_tree_item_0' class=''><img src='/images/dragdroptree/folder.png' class='folderImage' /><span class='textHolder'><span class=' name'>Корневой раздел</span><span class='controls'> - <a class='fancybox' href='/admin_pages/show_sorter/0'>Сортировать подразделы</a>#{pages_draggable_tree_import_export_links(0)}</span></span>"
      html << "<ul id='page_tree_childs_0'>"
    end
    for item in items
      html << "<li page_id='#{item.id}' id='page_tree_item_#{item.id}' class='treeItem'><img src='/images/dragdroptree/folder.png' class='folderImage' />"
      if item.show_in_menu == 0
        hidden = " style='color: silver;' "
      else
        hidden = ""
      end
      html << "<span class='textHolder'><span class='name' #{hidden}>#{item.name}</span>"
      html << "<span class='controls'> - <a href='/admin_pages/edit/#{item.id}'>Редактировать</a> | <a class='fancybox' href='/admin_pages/show_sorter/#{item.id}'>Сортировать подразделы</a>#{pages_draggable_tree_import_export_links(item.id)}"
      if item.is_system != 1
        html << " | <a href='/admin_pages/delete/#{item.id}' class='delete_page'>Удалить</a>"
      end
      html << "</span>"
      html << "</span>"
      if !item.all_pages.blank?
        html << "<ul id='page_tree_childs_#{item.id}' style='display: none;'>"
        html << pages_draggable_tree(item.all_pages, false)
        html << "</ul>"
      end
      html << "</li>"
    end
    if init 
      html << "</ul>"
      html << "</li>"
      html << "</ul>"
    end
    html
  end
  
  def tree_pages(categories, level=0, init=true)
    html = ""
    # The "Root" option is added
    # so the user can choose a parent_id of 0
    if init
        # Add "Root" to the options
        html << "
 <table cellspacing='0' cellpadding='0' border='0' width='100%' class='list' item_name='страницу' del_url='/admin_pages/delete/'>
 <thead>
  <tr>
    <th><b>Название</b></th>
    <th style='text-align:center'>Редактировать</th>
    <th style='text-align:center'>Удалить</th>
  </tr></thead><tbody>"
    end

    if categories.length > 0
      level += 1 # keep position
      slevel = ""
      i = 1
      while i < level
        slevel = slevel + "&#8212;"
        i = i + 1
      end
      categories.collect do |cat|
        if cat.is_system == 0
          link2del = btn_delete(cat)
        else
          link2del = ""
        end
        html << "<tr rowid='#{cat.id}'>
          <td><font color='black'>#{slevel}</font><a href='/admin_pages/edit/#{cat.id}'>#{cat.name}</a></td>
          <td align=center><a href='/admin_pages/edit/#{cat.id}'><img src='/admin/i/edit.gif' alt='Редактировать' width=15 height=15 border=0></a></td>
          <td align=center>" + link2del + "</td>
      </tr>"
        html << tree_pages(cat.admin_pages, level, false)
      end
    end
    html << "</tbody></table>\n" if init
    return html
  end
  
  
  def page_select(categories, model, name, selected=nil, level=0, init=true)
    html = ""
    # The "Root" option is added
    # so the user can choose a parent_id of 0
    if init
        # Add "Root" to the options
        html << "<select name=\"#{model}[#{name}]\" id=\"#{model}_#{name}\">\n"
        html << "\t<option value=\"0\""
        html << " selected=\"selected\"" if (selected == nil) || (selected.page_id == 0)
        html << ">Корневой раздел</option>\n"
    end

    if categories.length > 0
      level += 1 # keep position
      categories.collect do |cat|
        html << "\t<option value=\"#{cat.id}\" style=\"padding-left:#{level * 10}px\""
        html << ' selected="selected"' if (selected != nil) && (cat.id == selected.page_id)
        html << ">#{cat.name}</option>\n"
        html << page_select(cat.admin_pages, model, name, selected, level, false)
      end
    end
    html << "</select>\n" if init
    return html
  end

  
end