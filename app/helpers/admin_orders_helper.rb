module AdminOrdersHelper
  def order_dates(item)
    html = ""
    if !item.status_new_at.blank?
      html  << "Новый: #{standartDate(item.status_new_at)},  "
    end
    if !item.status_payed_at.blank?
      html  << "Оплачен: #{standartDate(item.status_payed_at)},  "
    end
    if !item.status_waiting_at.blank?
      html  << "Ожидает: #{standartDate(item.status_waiting_at)}, "
    end
    if !item.status_sended_at.blank?
      html  << "Отправлен: #{standartDate(item.status_sended_at)}, "
    end
    if !item.status_complete_at.blank?
      html  << "Доставлен: #{standartDate(item.status_complete_at)}, "
    end
    if !item.status_cancel_at.blank?
      html  << "Отменен: #{standartDate(item.status_cancel_at)}, "
    end
    html
  end
  
  def order_status_color(name)
    color = ""
    if name == "new"
      color = "red"
    end
    if name == "sended"
      color = "green"
    end
    if name == "waiting"
      color = "white"
    end
    if name == "payed"
      color = "LawnGreen"
    end
    if name == "cancel"
      color = "black"
    end
    if color == ""
      color = "orange"
    end
    color
  end
  
  def order_status(item)
    status = ""
    order_title = order_statuses.find{|el| el[1] == item.status}
    if !order_title.blank?
      status = "<font color='#{order_status_color(item.status)}'><b>#{order_title[0]}</b></font>"
    else
      status = "<font color='#{order_status_color(item.status)}'><b>#{item.status}</b></font>"    
    end
    return status + " "
  end
  
  def order_status_title(item)
    status = ""
    order_title = order_statuses.find{|el| el[1] == item.status}
    if !order_title.blank?
      status = "#{order_title[0]}"
    else
      status = "#{item.status}"    
    end
    return status
  end
  
  def order_statuses
    [["Новый", "new"], ["Оплачен", "payed"], ["Ожидает", "waiting"], ["Отправлен", "sended"], ["Доставлен", "complete"], ["Отменен", "cancel"]]
  end
end
