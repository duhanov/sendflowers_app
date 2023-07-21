module AdminCategoriesHelper

  def category_multi_select(model, name, selected=[], level=0, init=true, categories=[])
    html = ""
    # The "Root" option is added
    # so the user can choose a parent_id of 0
    if init
        categories = Category.find(:all, :conditions => ["category_id = 0"], :order => "p")
        html << "<select multiple='multiple' name=\"#{model}[#{name}][]\" id=\"#{model}_#{name}\">\n"
    end

    if categories.length > 0
      level += 1 # keep position
      categories.collect do |cat|
        html << "\t<option value=\"#{cat.id}\" "
        html << ' selected="selected"' if (selected.include?(cat))
        html << ">#{"&nbsp;&nbsp;"*level}#{cat.name}</option>\n"
        html << category_multi_select(model, name, selected, level, false, cat.all_categories)
      end
    end
    html << "</select>\n" if init
    return html
  end

    
  def category_select(categories, model, name, selected=nil, level=0, init=true)
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
        html << "\t<option value=\"#{cat.id}\" "
        html << ' selected="selected"' if (selected != nil) && (cat.id == selected.page_id)
        html << ">#{"&nbsp;&nbsp;"*level}#{cat.name}</option>\n"
        html << category_select(cat.all_categories, model, name, selected, level, false)
      end
    end
    html << "</select>\n" if init
    return html
  end

  def category_filter(categories, name, selected=nil, level=0, init=true)
    html = ""
    # The "Root" option is added
    # so the user can choose a parent_id of 0
    if init
        # Add "Root" to the options
        html << "<select name=\"#{name}\" id=\"#{name}\">\n"
        html << "\t<option value=\"\""
        html << " selected=\"selected\"" if (selected.to_s=="")
        html << ">--Любой раздел</option>\n"
        html << "\t<option value=\"0\""
        html << " selected=\"selected\"" if (selected.to_i == 0) && (selected.to_s!="")
        html << ">Корневой раздел</option>\n"
    end

    if categories.length > 0
      level += 1 # keep position
      categories.collect do |cat|
        html << "\t<option value=\"#{cat.id}\""
        html << ' selected="selected"' if (selected != nil) && (cat.id == selected.to_i)
        html << ">#{"&nbsp;"*level}#{cat.name}</option>\n"
        html << category_filter(cat.all_categories, name, selected, level, false)
      end
    end
    html << "</select>\n" if init
    return html
  end
  
  def categories_draggable_tree(items, init = true)
    html = ""
    if init
      html << '<ul class="myTree">'
      html << "<li page_id='0' id='page_tree_item_0' class=''><img src='/images/dragdroptree/folder.png' class='folderImage' /><span class='textHolder'><span class=' name'>Корневой раздел</span><span class='controls'> - <a class='fancybox' href='/#{params[:controller]}/show_sorter/0'>Сортировать подразделы</a></span></span>"
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
      html << "<span class='controls'> - <a href='/#{params[:controller]}/edit/#{item.id}'>Редактировать</a> | <a class='fancybox' href='/#{params[:controller]}/show_sorter/#{item.id}'>Сортировать подразделы</a>"
      #if item.is_system != 1
        html << " | <a href='/#{params[:controller]}/delete/#{item.id}' class='delete_page'>Удалить</a>"
      #end
      html << "</span>"
      html << "</span>"
      if !item.all_categories.blank?
        html << "<ul id='page_tree_childs_#{item.id}' style='display: none;'>"
        html << categories_draggable_tree(item.all_categories, false)
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
end
