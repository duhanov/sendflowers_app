module HelpHelper
  
  def help(t)
    "<small>#{t}</small>"
  end
  
  def help_sortable
    help("Вы можете использовать мышь для сортировки записей. Перетяните нужный элемент списка.")
  end
end