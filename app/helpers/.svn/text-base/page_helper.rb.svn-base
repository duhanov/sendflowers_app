module PageHelper
 
  
  
  def page_system_tags(page)
    arr = page.system_tags.to_s.split('|')
    html = ""
    if !arr.blank?
      html << "<br/><div style='background: #FFFF88; border: 1px solid black; padding: 5px;margin 5px;'><b>Вы можете использовать следующие теги:</b><br/><br/>"
      for item in arr
        html << item + "<br/>"  
      end
      html << "</div><br/>"
    end
    html
  end
  
  def pages_to_menu_items(pages)
    arr = []
    for page in pages
      menuitem = {:url => link2page(page), :title => page.name, :classes => page_li_classes(page), :subitems => []}
      #Вывод подразделов только у родительской категории
      if menuitem[:classes].include?("active")
        menuitem[:subitems] = page_submenu_items(page)
      end
      arr << menuitem
    end
    arr
  end
  
  


  def disks_category_li_classes(category)
    classes = []
    if is_current_disk_category(category)
      classes << "current"
    end
    if is_active_disk_category(category)
      classes << "active"
    end
    classes    
  end
  
  def category_li_classes(controller, category)
    classes = []
    if is_current_category(controller, category)
      classes << "current"
    end
    if is_active_category(controller, category)
      classes << "active"
    end
    classes    
  end
  
  def is_current_disk_category(category)
    if (params[:controller] == "disks") && (params[:action] == "category") && (params[:id] == category.url)
      return true
    else
      return false
    end  
  end
  
  def is_active_disk_category(category)
    res = false
    if (params[:controller] == "disks") && (params[:action] == "category") && (category.child_urls.include?(params[:id]))
      res =  true
    end
#    puts "parents ids: #{@disk.category.parent_ids.inspect}"
    if (params[:controller] == "disks") && (params[:action] == "show") && (@disk.category.parent_ids.include?(category.id))
      puts "category #{category.id} active"
      res =  true
    end
    return res
  end
  
  def is_current_category(contoller, category)
    if (params[:controller] == contoller) && (params[:action] == "category") && (params[:id] == category.url)
      return true
    else
      return false
    end  
  end
  
  def is_active_category(contoller, category)
    res = false
    if (params[:controller] == contoller) && (params[:action] == "category") && (category.child_urls.include?(params[:id]))
      res =  true
    end
    if (params[:controller] == contoller) && (params[:action] == "show") && (@product.category.parent_ids.include?(category.id))
      puts "category #{category.id} active"
      res =  true
    end
    return res
  end  
  
  def tires_category_li_classes(category)
    classes = []
    #if (params[:controller] == "tires") && (params[:action] == "summer") && (category.t == 1)
    #  classes << "active"
   # end
  #  if (params[:controller] == "tires") && (params[:action] == "winter") && (category.t == 0)
 #     classes << "active"
#    end
    if (params[:controller] == "tires") && (params[:action] == "category") && (params[:id] == category.url)
      classes << "current"
    end
    if (params[:controller] == "tires") && (params[:action] == "category")
      classes << "active"      
    end
    classes
  end
  
  def product_li_classes(controller, name)
    classes = []
    if (params[:controller] == controller) && (params[:action] == "show") && (params[:id] == name.url)
      classes << "active"
      classes << "current"
    end
    classes    
  end
  def disks_name_li_classes(name)
    classes = []
    if (params[:controller] == "disks") && (params[:action] == "show") && (params[:id] == name.url)
      classes << "active"
      classes << "current"
    end
    classes
  end
  
  
  
  
  def page_submenu_items(page)
    puts "page sysname: #{page.system_name}"
    case page.system_name
    when "tires_summer"
      return tires_summer_submenu_items
    when "tires_winter"
      return tires_winter_submenu_items
    when "disks"
      return disks_submenu_items
    when "tunings"
      return tuning_submenu_items
    else
      return pages_to_menu_items(page.menu_pages)
    end
  end
  
  def tire_li_classes(tireName)
    classes = []
    if is_current_tireCategory(tireName)
      
    end
  end
  
  def page_li_classes(page)
    classes = []
    if (!page.menu_pages.blank?) || (["tires_winter", "tires_summer", "disks", "tunings"].include?(page.system_name))
      classes << "parent"
    end
    if is_current_page(page)
      classes << "current"
    end
    if is_active_page(page)
      classes << "active"
    end
    puts "#{page.url} classes: #{classes.inspect}"
    classes
  end
  
  def is_active_tires_page(page)
    res = false
    if (params[:controller] == "tires") 
      if ((params[:action] == "category") || (params[:action] == "show"))
        if page.system_name == "tires"
          res = true
        end
        if (page.system_name == "tires_winter") && (@seazon == 0)
          res= true
        end
        if (page.system_name == "tires_summer") && (@seazon == 1)
          res= true
        end
      end
    end
    res
  end
  
  def is_active_disks_page(page)
    res = false
    if (params[:controller] == "disks") 
      if ((params[:action] == "category") || (params[:action] == "show"))
        if page.system_name == "disks"
          res = true
        end
      end
    end
    res
  end

  def is_active_products_page(controller, page)
    res = false
    if (params[:controller] == controller) 
      if ((params[:action] == "category") || (params[:action] == "show"))
        if page.system_name == controller
          res = true
        end
      end
    end
    res
  end

  
  def is_active_page(page)
    res = false
    if is_current_page(page)
      res = true
    else
      if !page.menu_pages.blank?
        for page2 in page.menu_pages
          if is_current_page(page2)
            res = true
            break
          end
        end
      end
    end
    #Диски
    if (res == false) && (is_active_disks_page(page))
      res = true
    end

    #Шины
    if (res == false) && (is_active_tires_page(page))
      res = true
    end
    #Тюнинг
    if (res == false) && (is_active_products_page("tunings", page))
      res = true
    end
    
    #Если новости
    if (res == false) && (page.system_name == "news") && (params[:controller] == "news")
      res = true
    end
    return res
  end
  
  def is_current_page(page)
    url = link2page(page)
    #Если активен контроллер
    if (params[:controller].to_s != "p") && ((url =~ /^\/#{params[:controller]}\/#{params[:action]}\/?[0-9a-zA-Z\?]*$/) || ((params[:action] == "index") && (url =~ /^\/#{params[:controller]}\/?$/)))
      puts "#{page.url} - current (active controller #{params[:controller]})"
      return true
    else
      res = false
      #Если просмотр страницы
      if (params[:controller] == "p") && (url =~ /^\/p\/[0-9a-zA-Z\-\_]+\/?[0-9a-zA-Z\?]*$/) && (!params[:id].blank?) && (page.url == params[:id]) && (page.url.to_s != "")
        puts "#{url} - current (show page)"
        res = true
      end
      #Если главная страница
      if (url == "/") && (params[:controller] == "p") && (params[:id] == "index")
        puts "#{url} - current (index page)"
        res = true
      end
      #Если новости
      if (url == "/news") && (params[:controller] == "news") && (params[:action] == "index")
        puts "#{url} - current (news page)"
        res = true
      end
      if res == false
        puts "#{url} - NO current)"
      end
      return res
    end
  end
  
  def show_page(name)
    page = Page.find_by_url(name)
    if !page.blank?
      return page.body
    end
  end
  
  def link2page(page)
    if page.url == "index"
      return "/"
    else
      case page.system_name
      when "tires"
        return "/tires"
      when "tires_winter"
        return "/tires/winter"
      when "tires_summer"
        return "/tires/summer"
      when "news"
        return "/news"
      when "disks"
        return "/disks"
      when "tunings"
        return "/tunings"
      when "podbor"
        return "/podbor"
      when "prostavki"
        return "/prostavki"
      when "contacts"
        return "/contacts"
      else
        return "/p/" + page.url.to_s            
      end
    end
  end

end