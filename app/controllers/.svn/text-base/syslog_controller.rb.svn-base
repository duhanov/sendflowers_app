class SyslogController < ApplicationController
  layout "admin"
  
  def show
    item = Syslog.find_by_id(params[:id])  
    if !item.blank?
      render :text => "#{item.body}"
    else
      render :text => "Can't find item"
    end
  end
  
  def list
    @page_title = "События системы"
    if params[:filter].to_s == ""
      @items = Syslog.items_page(params[:page])
    else
      @items = Syslog.items_page(params[:page], ["t = ?", params[:filter]])      
    end
  end
  
  def clear
    for item in Syslog.find(:all)
      item.destroy
    end
  end
end
