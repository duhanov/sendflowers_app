# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def trans(t)
    translate(t)
  end
  
  def translate(text)
    I18n.t text 
  end
  
  def menu2_li(title, url)
    url = url.to_s.gsub("\n","").gsub("\r","")
    if request.request_uri.to_s =~ /^#{url.to_s.gsub("/","\\/")}/ && url.to_s.strip != ""
      return "<li class='active'><a>#{title}</a></li>"
    else
      return "<li><a href='#{url}'>#{title}</a></li>"
    end
  end

  def menu1_li(title, url)
    if url =~ /\/#{params[:controller]}/
      return "<li class='active'><a>#{title}</a></li>"
    else
      return "<li><a href='#{url}'>#{title}</a></li>"
    end
  end
  
  def gen_time
    "<!--Generated: #{standartDateTime(DateTime.now)}-->"
  end
  
  def menu_text(t)
    t = t.to_s.gsub(/([a-zA-Zа-яА-Я0-9]{2,100})\s([a-zA-Zа-яА-Я0-9]{2,100})/,"\\1<br>\\2")
    t = t.to_s.gsub(/([a-zA-Zа-яА-Я0-9]{2,100})\/([a-zA-Zа-яА-Я0-9]{2,100})/,"\\1/<br>\\2")
    t
  end

  def category_li(title,url,desc="")
    "<li><a href='#{url}'><big>#{title}</big> #{desc}</a></li>"
  end
  
  def meta_tags
    html = ""
    html << "<meta name=\"description\" content=\"#{meta_description}\" />\n"
    html << "<meta name=\"keywords\" content=\"#{meta_keywords}\" />\n"
    html
  end
  
  def button(title, width="200px")
    "<div class=\"green_angle_btn_f3\" styl=\"width:#{width};\"><div>#{submit :title => "#{title}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"}</div></div>"
  end
  
  def is_admin
    if (!current_user.blank?) && (!current_user.roles.blank?) && (current_user.roles[0].name == "Администратор")
      return true
    else
      return false
    end
  end
  
  def menu_link(page)
    
  end
  
  def meta_keywords
    res = ''
    if !@page.blank?
      res = @page.meta_keywords.to_s      
    end
    if !@category.blank?
#      res = @category.meta_keywords.to_s
       if @language == "ru"
        res = @category.meta_keywords.to_s
       else
        res = @category.meta_keywords_en.to_s
       end
    end
    if !@item.blank?
      res = @item.meta_keywords.to_s
    end
    item = ""
    item = @product if !@product.blank?
    item = @f if !@f.blank?
    if !item.blank?
       if @language == "ru"
        res = item.meta_keywords.to_s
       else
        res = item.meta_keywords_en.to_s
       end
    end

    if res == ""
      res = Option.get('meta_keywords')
    end
    return res
  end
  
  def meta_description
    res = ''
    if !@page.blank?
      res = @page.meta_description.to_s      
    end
    if !@category.blank?
       if @language == "ru"
	res = @category.meta_description.to_s
       else
        res = @category.meta_description_en.to_s
       end
    end
    if !@item.blank?
      res = @item.meta_description.to_s
    end

    item = ""
    item = @product if !@product.blank?
    item = @f if !@f.blank?
    if !item.blank?
       if @language == "ru"
        res = item.meta_description.to_s
       else
        res = item.meta_description_en.to_s
       end
    end
    if res == ""
      res = Option.get('meta_description')
    end
    return res    
  end
  
   def show_yesno(v)
    if v == true || v == 1 || v == "1"
      return "Да"
    else
      return "Нет"
    end
  end

  def standartDate(d)
    if !d.blank?
      return d.strftime('%d.%m.%Y')
    end
  end

  def standartTime(d)
    if !d.blank?
      return d.strftime('%H:%M:%S')   
    end
  end
  
  def standartDateTime(d)
    if !d.blank?
      return d.strftime('%d.%m.%Y %H:%M:%S')   
    end
  end
 
  def nav_link(title, href)
    if request.request_uri == href
      _class = "class='active'"
    else
      _class = ""
    end
    "<a #{_class} href='#{href}'>#{title}</a>"
  end

  def submit(p)
    "<input type='submit' value='#{p[:title]}'/>"
  end
  
  def tree_options(categories, model='', name='', selected=nil, level=0, init=true)
    html = ""
    if init
      # Add "Root" to the options
    end

    if categories.size > 0
      level += 1
      for cat in categories
        html << "\t<option id=\"#{model}_#{name}_#{cat.id}\" value=\"#{cat.id}\" style=\"padding-left:#{level * 10}px\""
        if (!selected.blank?) && (selected.category_id == cat.id)
          html << ' selected="selected"' 
        end
        html << ">#{cat.name}</option>\n"
        html << tree_options(cat.categories, model, name, selected, level, false)
      end
    end
    return html
  end

  def tree_select(categories, model='', name='', selected=nil, level=0, init=true)
    html = ""
    html << "<select name=\"#{model}[#{name}]\" id=\"#{model}_#{name}\">\n"
    html << tree_options(categories, model, name, selected, level, init)
    html << "</select>\n" if init
    return html
  end

                        
  def print_way(way=@way, show_root = true)
    if !@way.blank?
    start_tag = '<div class="crumb">'
    end_tag = '</div>'
    if show_root
      r = start_tag + '<a href="/">' + I18n.t('main_page') + '</a> '
    else
      r = start_tag
    end
    for w in way
      if w == way.last
      r = r + "/ <span>#{w[0]}</span>" + end_tag
      else
      r = r + "/ <a href='#{w[1]}'>#{w[0]}</a> "
      end
    end
    #r = r.gsub(/^(<p class\=\"breadcrumbs\">\/)/, '<p class="breadcrumbs">')
    #r = r + "</p>"
    return r
    end
  end
  
  def trans_option(name)
    translate_name(Option.get(name))
  end
  
  def print_page_title
    if !@page_title.blank?
      if @page_title.is_a?(Array)
        title = ""
        for i in 0..@page_title.size - 1
          if @page_title[i].is_a?(Array)
            title = title + @page_title[i][0].to_s + Option.get("sep").to_s          
          else
            title = title + @page_title[i].to_s + Option.get("sep").to_s          
          end
        end
#        title = title + @page_title[@page_title.size - 1].to_s
        return title + translate_name(Option.get("site_name")).to_s
      else
        return "#{@page_title}#{Option.get("sep")}#{translate_name(Option.get("site_name"))}"
      end
    else
      return translate_name(Option.get("root_title"))
    end
  end

end
