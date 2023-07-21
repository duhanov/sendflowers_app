module TranslateHelper
  def help_translate
    "<b>|</b> - этот знак разделяет русское название от английского. Например: Русское название|English name"
  end
  
  def translate_name(name)
    is = name.to_s.split("|")
    if is.size == 1
      return name
    else
      if @language == "ru"
        return is[0]
      else
        return is[1]
      end
    end
  end
end