module ProductsHelper

def number_with_delimiter(number, options = {})
  options.symbolize_keys!

  begin
    Float(number)
  rescue ArgumentError, TypeError
    if options[:raise]
      raise InvalidNumberError, number
    else
      return number
    end
  end

  defaults = I18n.translate(:'number.format', :locale => options[:locale], :default => {})
  options = options.reverse_merge(defaults)

  parts = number.to_s.to_str.split('.')
  parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")
  parts.join(options[:separator]).to_s

end
  
  def order_product_title(p,html=false)
    if (!p.blank?) && (!p.product.blank?) && (!p.product.block_part.blank?) && (!p.product.car.blank?) && (!p.producer.blank?)
      if html
      return "<b>Арт. #{p.product.art}</b>, #{p.product.block_part.name} (#{p.product.car.year1}-#{p.product.car.year2}), производитель: #{p.producer.name}"
      else
      return "Арт. #{p.product.art}, #{p.product.block_part.name} (#{p.product.car.year1}-#{p.product.car.year2}), производитель: #{p.producer.name}"
      end
    end
  end

  def get_amount(i)
    if (session[:currency].blank?) || (session[:currency] == "usd") 
      return  i.to_f.to_s.gsub(/\.0$/,"")
    else
      return  (i.to_f * Option.get("kurs_usd").to_f).to_s.gsub(/\.0$/,"")
    end    
  end
  



  def show_amount(i,sep = "&nbsp;")
    if (session[:currency].blank?) || (session[:currency] == "usd") 
      return  (number_with_delimiter(i.to_f, :delimiter => sep).gsub(/\.0$/,"")+sep+"$")
    else
      #i = (((i.to_f * Option.get("kurs_usd").to_f / 100).to_f.ceil)*100).to_i
i = i.to_f * Option.get("kurs_usd").to_f

      return  (number_with_delimiter(i, :delimiter => sep).gsub(/\.0$/,"")+sep+"руб.")
    end
  end
  


  def link2buy(product)
    "/order/buy/#{product.id}"
  end
  
  def link2order(product)
    "/order/order/#{product.id}"
  end
  
  def product_price_value(v)
    "#{number_with_delimiter(v.to_f, :delimiter => " ")} руб."
  end
  
  def product_price1(item)
    product_price_value(item.price1)
  end
  
  def product_price2(item)
    product_price_value(item.price2)
  end

  def product_price3(item)
    product_price_value(item.price3)
  end

  
  def product_image(item, _class = "thumb")
    if item.image.blank?
      return "/images/thumb/missing.png"
    else
      return item.image.url(_class)
    end
  end
  
  def link2products(producer)
    "/products/list/#{producer.url}"
  end
  
end
