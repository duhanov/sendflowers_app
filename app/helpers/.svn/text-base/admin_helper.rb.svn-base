require "uri"
module AdminHelper

  def pagination(items)
    will_paginate items, :prev_label => "« Предыдущая страница", :next_label => "Следующая страница »"

  end

  def admin_tabs2(tabs, name = "root")
    res ="<div class=\"tabs_#{name}\" id=\"tabs_#{name}\"><ul>"
    for tab in tabs
      res << "<li><a href=\"#{tab[1]}\"><span>#{tab[0]}</span></a></li>"
    end
    res << '</ul><div class="clear"></div></div>'
    res <<"<script type=\"text/javascript\">\n"
    res << "    $(document).ready(function(){\n" if params[:ajax].blank?
    res << "        $('#tabs_#{name}').tabs({
              //При выбори таба обновляем CodeMirror
              select: function(event, ui) {
              }
            });\n"
    res << "    });\n" if params[:ajax].blank?
    res << "</script>"
    res
  end

  def admin_head
    html = "#{javascript_include_tag 'jquery.qtip-1.0.0-rc3.min'}"
    html << <<END_OF_TEXT

END_OF_TEXT

    html
  end
  


  def select_language
    select :item, :language, [["Русский", "ru"], ["Английский", "en"]]  
  end
  
  def moderate_link(item)
    if !item.moderated
      l = link_to_remote("<img src='/admin/i/chbox.gif' alt='Одобрить' width=12 height=12 border=0>Одобрить", :update => "moderated_" + item.id.to_s, :url => "/#{params[:controller]}/moderate/" + item.id.to_s, :method => :get)
      return "<div id=\"moderated_#{item.id}\">#{l}</div><br>"
    end
  end
  
  def add_progress
    "<span id='add_progress' style='display:none;'>Идет добавление... <img src='/images/ajax/load/11.gif'/></span>"    
  end
  def print_admin_way(way, show_root = true)
    if !way.blank?
    if show_root
      r = '<p class="breadcrumbs"><a href="/">Главная</a> '
    else
      r = '<p class="breadcrumbs">'
    end
    for w in way
      r = r + "&raquo; <a href='#{w[1]}'>#{w[0]}</a> "
    end
    r = r.gsub(/^(<p class\=\"breadcrumbs\">\&raquo\;)/, '<p class="breadcrumbs">')
    r = r + "</p>"
    
    return r
    end
  end

  def standartDate(d)
    if !d.blank?
      return d.strftime('%d.%m.%Y')
    end
  end

  def mysqlDate(d)
    if !d.blank?
      return d.strftime('%Y-%m-%d')
    end
  end
  
  def mysqlDateTime(d)
    if !d.blank?
      return d.strftime('%Y-%m-%d %H:%M:%S')
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
  
    
  def markitup_btn(tag_name)
    html ="<a href='#' id='insert_#{tag_name}'>[#{tag_name}]</a>"
    html << "<script>$('#insert_#{tag_name}').click(function() {
        $.markItUp( {   //openWith:'<opening tag>',
            //closeWith:'<\/closing tag>',
            placeHolder:'[#{tag_name}]'
          }
        );
        return false;
      });</script>"
    html
  end
  
  def flashes
    html = ""
    flash.each do |name, msg|
        html << content_tag(:div, "<div>#{msg}</div>", :id => "flash_#{name}", :class => "shadow")
    end
    return html
  end
  
  def sortable_item(item, &content)
    concat("<li class='ui-state-default' id='item_#{item.id}'><span class='ui-icon ui-icon-arrowthick-2-n-s'></span>")
    concat(capture(&content))
    concat("</li>")
  end
  
  def sortable(update_url, &content)
    if @count_sortables.blank?
      @count_sortables = 1
    else
      @count_sortables = @count_sortables + 1
    end
    id = "sortable_#{@count_sortables}_#{update_url.parameterize}"
    id_status = "sortable_#{@count_sortables}_status_#{update_url.parameterize}"
    id_errors = "sortable_#{@count_sortables}_errors_#{update_url.parameterize}"
    concat("<div id='#{id_errors}' style='display:none;'></div><div id='#{id_status}'></div><ul id='#{id}' class='sortable'>")
    concat(capture(&content))
    concat("</ul>")
    script = <<END_OF_STRING
      <script>
      $(document).ready(function(){
        $('##{id}').sortable({
          "update": function(){
            $('##{id_status}').append('<div id="flash_notice">Идёт обновление сортировки...</div>');
            $.ajax({
              'type': "POST",
              'url': "#{update_url}",
              'data': $("##{id}").sortable('serialize') + '&authenticity_token=' + window._token,
              'dataType': 'script',
              'success': function(){
                $('##{id_status}>div:first-child').remove();
              },
              'error': function(XMLHttpRequest, textStatus, errorThrown){
                $('##{id_status}>div:first-child').remove();
                $('##{id_errors}').show();
                $('##{id_errors}').append('<div id="flash_error">' + textStatus + '</div>');
              }
            });
          }
        });
        $("##{id}").disableSelection();
      });
      </script>
    
END_OF_STRING

      concat(script)
    end
  
  def edit_text_field(title, obj, field)
    "<tr><td>#{title}</td><td>#{text_field obj, field}</td></tr>"
  end
 
  def edit_image(title, obj, field, thumb_class="thumb")
    "<tr><td>#{title}</td><td><img src='#{@item.image.url(thumb_class)}'/><br/><input type='file' name='#{obj}[#{field}]'/></td></tr>"
  end
  
  def admin_tabs(titles, current = "")
    if !params[:tab_selected].blank?
      current = params[:tab_selected]
    end
    if current == ""
      current = titles[0].parameterize.downcase
    end
    @admin_tab_current = current
    html = "<div id=\"t3\">"
    html2 = "<script>\nfunction showFrame(id){\n$('.tab_selected').val(id);\n"
    for title in titles
      name = title.parameterize.downcase
      if name == current
        _class = "current"
      else
        _class = ""
      end
      html << "<span class=\"#{_class}\" id=\"#{name}A\"><a href=\"#\" onclick=\"showFrame('#{title.parameterize.downcase}');return false;\">#{title}</a></span>"
      html2 << "$('##{name}DIV').hide();\n";
      html2 << "$('##{name}A').removeClass('current');\n"
    end
    html2 << "$('#' + id + 'DIV').show();\n";
    html2 << "$('#' + id + 'A').addClass('current');\n\};\n</script>\n"
    html << "</div>"
    html << html2
    return html
  end
  
  def admin_tab(title, &content)
    name = title.parameterize.downcase
    if name == @admin_tab_current
      _style = ""
      concat("<input type='hidden' name='tab_selected' class='tab_selected' value='#{name}'>")
    else
      _style = "display: none"
    end
    concat("<div id='#{name}DIV' style='#{_style}'>")
    concat(capture(&content))
    concat("</div>")
  end
  
  def edit_meta
    "<tr>
      <td>
        Мета-теги
      </td>
      <td>
        <a href=\"#meta_tags\" class='admin_slide'>Показать/Скрыть</a>
        <div id=\"meta_tags\" style='display: none;'>
          META-Keywords:<br/>
          #{text_area_counter :item, :meta_keywords}<br/>
          META-Description:<br/>
          #{text_area_counter :item, :meta_description}<br/>
        </div>
      </td>
    </tr>"    
  end

  def edit_meta_ru_en
    "<tr>
      <td>
        Мета-теги
      </td>
      <td>
        <a href=\"#meta_tags\" class='admin_slide'>Показать/Скрыть</a>
        <div id=\"meta_tags\" style='display: none;'>
          META-Keywords(рус.):<br/>
          #{text_area_counter :item, :meta_keywords}<br/>
          META-Description(рус.):<br/>
          #{text_area_counter :item, :meta_description}<br/>
          META-Keywords(англ.):<br/>
          #{text_area_counter :item, :meta_keywords_en}<br/>
          META-Description(англ.):<br/>
          #{text_area_counter :item, :meta_description_en}<br/>
        </div>
      </td>
      <td></td>
      <td></td>
    </tr>"    
  end

  def td_active(item)
    "<td class='edit_yesno' field='active'>#{show_yesno(item.active)}</td>"
  end
  
  def tr(*item, &content)
    if item == []
      concat("<tr>")
    else
      concat("<tr rowid='#{item[0].id}' id='#{item[0].id}'>")
    end
    concat(capture(&content))
    concat('</tr>')   
  end


  def sort_link(title, sort_up, sort_down, page = "")
    html = ""
    case @sort
      when sort_up
        img = "<img src='/images/up.png'>"
        url = "/#{params[:controller]}/#{params[:action]}/?sort=#{URI.escape(sort_down)}" 
      when sort_down
        img = "<img src='/images/dn.png'>"
        url = "/#{params[:controller]}/#{params[:action]}/?sort=#{URI.escape(sort_up)}"
      else
        img = ""
        url = "/#{params[:controller]}/#{params[:action]}/?sort=#{URI.escape(sort_up)}" 
    end
    url = url + "&q=#{URI.escape(params[:q].to_s)}"
    if !filters.blank?
      for key in filters
        url << "&#{key}=#{URI.escape(params[key].to_s)}"
      end
    end
    html = img + "<a href='#{url}'>" + title + "</a>"
    return html
  end 
  
  
  def table_with_sort_links(headers, urls={}, classes="list", &content)
    if urls.blank?
      urls={:item_name=> model_title[:what], :del_url=> "/#{params[:controller]}/delete/",:update_url=>"/#{params[:controller]}/update/"}
    end
    concat("<table cellspacing='0' cellpadding='0' border='0' width='100%' class='#{classes}' del_url='#{urls[:del_url]}' update_url='#{urls[:update_url]}' item_name='#{urls[:item_name]}'")
    concat('<thead><tr>')
    for h in headers
      if h.is_a?(Array)
        concat('<th><b>')
        if h.size == 3
          concat(sort_link(h[0], h[1], h[2], params[:page]))
        else
          puts h[1]
          concat(sort_link(h[0], h[1], h[1] + " DESC", params[:page]))          
        end
        concat('</b></th>')
      else
        concat("<th><b>#{h}</b></th>")
      end
    end
    concat('</tr></thead><tbody>')
    concat(capture(&content))
    concat('</tbody></table>')      
  end
  
  def admin_table(item_name="", update_url="", delete_url="", &content)
    concat("<table id='admin_table' update_url='#{update_url}' item_name='#{item_name}' del_url='#{delete_url}' cellspacing=\"0\" cellpadding=\"0\" border=\"0\" width=\"100%\" class=\"list\">")
    concat(capture(&content))
    concat('</table>')   
  end
  

  
  def admin_current_page
   #return @controller.inspect
#   return "#{params[:controller]}/#{params[:action]}"
    if @admin_page_link[1] =~ /\/#{params[:controller]}\/#{params[:action]}\/?[0-9a-zA-Z\?]*/
      return "class='current'"
    end 
  end
  
  def admin_page(links = [],&content)
#    @page_title = title
    @page_links = links
    concat(render :file => "widgets_admin/_admin_page")
    concat(capture(&content))
#    concat('</ul></div>')    
  end


  def admin_nav_counter_link(title, _count, hide_if_null = false)
    if _count > 0
      title = title + " (<font style='color:red'>#{_count}</font>)"
    end
    title = "<b>#{title}</b>"
    if (_count == 0) && (hide_if_null == true)
      title = ""
    end
    return title
  end


  def calendar(model = "item", field = "date")
    id = "\##{model}_#{field}"
    "#{text_field model, field}<script>$('#{id}').datePicker({inline: true}).bind('dateSelect', function(e, selectDate){$('#{id}').val(selectedDate.asString)})</script>"  
  end
  
  def imageuploader_item(item, href_url, image_url, name = 'item[image]')
    name = name.gsub(/\[/, '_').gsub(/\]/, '_')
    <<END_OF_STRING
    
  <div id="#{name}container#{item.id}" class="#{name}container img-loading">
    <div><a rel="#{name}gallery" href="#{href_url}" class="#{name}gallery"><img id="#{name}img#{item.id}" image_id="#{item.id}" src="#{image_url}" class="#{name}img"/></a></div>
  </div>
    
END_OF_STRING

  end


  def form_item(title="", form_class=".app .form-horizontal", &content)
    opts = {}
    if !@form.blank? && @form.class.name == "BrickForm"
      opts = {:parent_panel => "form#{@form.id}"} 
    else
      opts = {:parent_panel => form_class} 
    end
    opts[:selector_icon] = ""
  concat("<div class=\"form-group\">
    <label class='col-lg-3 control-label'>#{title}</label>
    <div class='#{form_class} col-lg-4'>")
    concat(capture(&content))
  concat("</div>
  </div>")
  end


  
  def btn_del_row(title = "")
    if title == ""
      return "<img src=\"/admin/i/delf.gif\" alt=\"Удалить\" title=\"Удалить\" onClick=\"remove_row(this); return false;\" style=\"cursor: pointer; \" />"
    else
      return "<a style='cursor: pointer;' title=\"Удалить\" onClick=\"remove_row(this); return false;\">#{title}</a>"    
    end
  end

  def ajax_form_loading
  <<END_OF_STRING
  <iframe id="edit_frame" name="edit_frame" style="display: none"></iframe>
<div id="form_submit_progress" style="display: none; padding-top: 100px;">
  <center><img src="/images/ajax/load/18.gif" alt="Loading..." /></center>
</div>
  
END_OF_STRING
    
  end

  def YesOrNo(i)
    if i.to_i == 0
      return "Нет"
    else
      return "Да"
    end
  end
  
  def btn_edit(item, controller = params[:controller], action = "edit" , ajax = {}, helpHintId = "") 
    helpHint = "class='fancybox'"
    if helpHintId != ""
       helpHint = "class='fancybox helpHint' helpHint='##{helpHintId}'"
    end
    if ajax == {}
      return "<a id='edit_btn_#{item.id}' href='/#{controller}/#{action}/#{item.id}'><img src='/admin/i/edit.gif' alt='Редактировать' width=15 height=15 border=0></a>"    
    else
      return "<a #{helpHint} id='edit_btn_#{item.id}' href='/#{controller}/#{action}/#{item.id}?ajax=true'><img src='/admin/i/edit.gif' alt='Редактировать' width=15 height=15 border=0></a>"    
    end
  end
  
  def link2user(user)
    if !user.blank?
      return "<a target='_blank' href='/admin_users/" + user.id.to_s + "'>" + user.email.to_s + "</a>"
    end
  end
  
  def gen_password(id)
    return "<input type=\"button\" onClick=\"$('#" + id + "').val(GeneratePassword());\" value=\"<--Генерировать\">"
  end  
  
  def quick_add(title = "Добавить", url = "", &content)
    if @quick_add_count.blank?
      @quick_add_count = 1
    else
      @quick_add_count = @quick_add_count + 1      
    end
    id = "quick_add_#{@quick_add_count}"
    id_btn = "quick_add_btn_#{@quick_add_count}"
    concat("<div style='display:none;' id='#{id}'>")
    concat("<form action='#{url}' method='post' enctype='Multipart/form-data'><input type='hidden' name='authenticity_token' value='#{form_authenticity_token}'/>")
    concat(capture(&content))
    concat("<br/>#{submit_tag(title)} <a href='#' onClick='$(\"##{id_btn}\").show(); $(\"##{id}\").slideToggle(); return false;'>Отмена</a><br/><br/></div>")
    concat("</form>")
    concat("<a href='#' onClick='$(this).hide();$(\"##{id}\").slideToggle(); return false;' id='#{id_btn}'><img src='/admin/i/add.gif'/>#{title}</a>")
  end
  
  def btn_del(item = '', title = '')
    btn_delete(item, title)
  end
  
  def btn_delete(item, title = '')
    btn_del_row
  end
  
  def btn_add(title = "Добавить")
    #return "<a id='add_btn' href='#' onClick='this.style.display=\"none\"; $(\"add_form\").style.display=\"block\"; return false;'>" + title + "</a>"
    "<a id='add_btn' href='#' onClick='$(this).hide(); $(\"#add_form\").slideToggle(); return false;'><img src='/admin/i/add.gif'/>#{title}</a>"

  end

  def btn_add_cancel()
    return "<a href='#' onClick='$(\"#add_btn\").show(); $(\"#add_form\").slideToggle(); return false;'>Отмена</a>"
  end
  

  def text_area_counter(model, prop, size = "50x5")
 
    string = <<END_OF_STRING
    #{text_area model, prop, :size => size, :class => "textarea_counter"}

END_OF_STRING

    return string
  end



  def script_delete(controller = "controller", action = "action", item_name = 'запись')
  end
end