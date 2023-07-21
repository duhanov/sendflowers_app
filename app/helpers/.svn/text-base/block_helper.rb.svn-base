 module BlockHelper
  def get_block(name)
    res = ""
    block = Block.find(:first, :conditions => ["name = ? AND language = ?", name, @language])
    if !block.blank?
      if is_admin
#        res = "<div style='display:inline;' class='admin_block' id='admin_block_#{block.id}' block_id='#{block.id}'>#{block.body}</div>"
        res = "<!--Block:#{name}-->#{block.body}<!--/Block:#{name}-->"        
      else
        res = "<!--Block:#{name}-->#{block.body}<!--/Block:#{name}-->"        
      end
    end
    return res
  end

  def show_block(name)
    return get_block(name)
  end


  
  def get_block_menu(block)
    res = []
    if !block.blank?
      if block.body.to_s.strip != ""
        res = Marshal.load(block.body)  
      end
    end
    return res
  end
  
  def admin_blocks_list(t)
    @blocks_t = t
    @blocks = Block.find(:all, :conditions => ["t = ?", @blocks_t], :order => "p") 
    return render :file => "admin_blocks/_blocks"
   # return render :file => "admin_blocks/_blocks"
  end
  
#  def get_block(name)
 #   res = ""
  #  block = Block.find(:first, :conditions => ["name = ?", name])
   # if !block.blank?
    #  res = block.body
    #end
    #return res
 # end
  
  def get_block_title(block)
    if block.content_type == 'catalog'
      return 'Каталог'
    end
    if block.content_type == 'contacts'
      return 'Контакты'
    end
    
    if block.content_type == 'menu'
      return 'Меню'
    end
    if block.content_type == 'search'
      return 'Форма поиска'
    end
    if block.content_type == 'top10'
      return 'TOP-10'
    end
    if block.content_type == 'banner'
      return 'Баннер'
    end
    if block.content_type == 'last_articles'
      return 'Последние статьи'
    end
    if block.content_type == 'text'
      if block.runame.to_s.strip != ""
        return block.runame
      else
        return 'Текстовый блок'    
      end
    end
  end
  
  def is_system_block(block)
    return blocks_types().include?(block.name)
    
  end

  def blocks_types()
    return ["menu", "top10", "search"]
  end
end