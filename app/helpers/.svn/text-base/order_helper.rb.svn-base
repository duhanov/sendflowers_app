require 'iconv'

module OrderHelper
  def history_order_status(item)
    status = ""
    order_title = order_statuses.find{|el| el[1] == item.status}
    _class = item.status
    if item.status == "waiting"
      _class = "wait"      
    elsif item.status == "payed"
      _class = "paid"
    elsif item.status == "complete"
      _class = "delivered"
    elsif item.status == "sended"
      _class = "sent"
    elsif item.status == "cancel"
      _class = "canceled"
    end
    if !order_title.blank?
      status = "<div class='#{_class}'>#{order_title[0]}</div>"
    else
      status = "<div class='#{_class}'>#{item.status}</div>"
    end
    if item.status == "new" || item.status == "waiting"
      if item.payment_url != "/order/complete/#{item.id}"
        status << "<a href='#{item.payment_url}'>#{trans('pay')}</a>"
      end
    end
    return status   
  end

  
    def show_amount2(i,sep = "&nbsp;")
      return  (number_with_delimiter(i.to_f, :delimiter => sep).gsub(/\.0$/,"")+sep+"$")
  end

  def show_payment_text(text)
    text = text.to_s.gsub("KURS_USD", Option.get("kurs_usd"))
    if !@order.blank?
      text = text.gsub("PAYMENT_PRICE_USD", (@order.total_price + @order.delivery_price).to_s)
      text = text.gsub("PAYMENT_PRICE_RUB", (@order.total_price_rub + @order.delivery_price_rub).to_s)
    end
    text
  end
  
  def delivery_name(item)  
    is = item.name.to_s.split("|")
    if is.size == 1
      return item.name
    else
      if @language == "ru"
        return is[0]
      else
        return is[1]
      end
    end
  end
  
  def toUTF8(s)
    ic = Iconv.new('UTF-8','WINDOWS-1251')
    ic.iconv(s)
  end
  
  def toWIN1251(s)
    ic = Iconv.new('WINDOWS-1251', 'UTF-8')
    ic.iconv(s)
  end
  
  def order_price(order, currency)
    
  end
  
  def order_options(order)
    if order.leave_order_to_friends
      return translate 'leave_order_to_friends'#"В случае отсутвия получателя на месте, оставить заказ родственникам или друзьям"
    end
  end
  
  def order_services(order)
    html = "#{trans('additional_services')}: "
    for order_item in order.order_items
      if (!order_item.product.blank?) && (order_item.product.is_service)
        html << "#{order_item.product.name} - #{show_amount(order_item.price)}; "
      end
    end
    html
  end
  
  def order_services2(order)
    html = "#{trans('additional_services')}: "
    for order_item in order.order_items
      if (!order_item.product.blank?) && (order_item.product.is_service)
        html << "#{order_item.product.name} - #{show_amount2(order_item.price)}; "
      end
    end
    html
  end

  def order_name(order)
    "#{order.firstname} #{order.patronymic} #{order.lastname}"    
  end
  
  def order_sender_name(order)
    "#{order.sender_firstname} #{order.sender_patronymic} #{order.sender_lastname}"    
  end

  def order_sender_address(order)
    "#{order.sender_country}, #{order.sender_address}"
  end
  
  def order_address(order)
=begin
    if order.call_to_known_address 
      return translate 'call_to_konwn_address'
      #"Узнать адрес, созвонившись с получателем"
    else
      return "#{order.country},  #{order.zip} #{order.city}, #{order.address}"
    end
=end
      return "#{translate('call_to_konwn_address')}, #{order.country},  #{order.zip} #{order.city}, #{order.address}"
  end
  
  def order_all_telephones(order)
    html = order_telephone(order) + " "
    if !order.phones.blank?
      for telephone in order.phones
        html << telephone(telephone) + "; "
      end
    end
    html
  end
  
  def order_telephone(order)
    #if order.cant_call
     # return "Не надо звонить, это сюрприз"
    #else
      #return telephone(order)
    #end    
    html = telephone(order)
    if order.cant_call
      html = "#{translate 'dont_call_surprise'}. #{html}"
    end
    return html
  end
  
  def telephone(order)
    if order.type.to_s != "Order"
      "#{order[:country_code]} #{order[:city_code]} #{order[:telephone]}"
    else
      "#{order.country_code} #{order.city_code} #{order.telephone}"
    end
  end
  
  def order_parthner_info(item)
    if (!item.blank?)&&(!item.parthner.blank?)
      return "<a target='_blank' href='/admin_users/edit/#{item.parthner.id}'>#{item.parthner.email} (#{item.parthner.name})</a>, #{item.parthner.parthner_percent}% = #{(item.total_price*item.parthner.parthner_percent/100)} руб."
    end
  end
  
  def order_shop(item)
    if (!item.blank?) && (!item.shop.blank?)
      return item.shop.domain
    end
  end
end
