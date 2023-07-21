module FilterHelper
  def filters
    ["category", "block_part"]
  end
  
  def f_title(f)
    if f.value =~ /^(.*)\|(.*)$/
      if @language == "ru"
        return "#$1"
      else
        return "#$2"
      end
    else
      return f.value
    end
  end
end