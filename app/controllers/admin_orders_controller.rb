include AdminOrdersHelper
include AdminHelper
#require 'geoip'

class AdminOrdersController < ApplicationController
  layout "admin"
  
  
  def notify
    @page_title = "Настройка уведомлений о заказах."  
  end
  
  def search
#    @geoip ||= GeoIP.new("#{RAILS_ROOT}/db/GeoIP.dat") 
    @items = Order.search_page(params[:page], params[:q])
    if @items.blank?
      render :text => "Ничего не найдено."
    else
      render :partial => "orders"    
    end
  end
  



  attr_reader :order


  
  def list
 #   @geoip ||= GeoIP.new("#{RAILS_ROOT}/db/GeoIP.dat") 
    @page_title = "Список заказов"
    filter_str = ""
    filter_arr = []
    if !params[:filter].blank?
      if (!params[:date1].blank?) && (params[:date1].to_s.strip != "")
        filter_str << "DATE(created_at) >= ? AND "
        filter_arr << params[:date1].gsub(/([0-9]+)\.([[0-9]+)\.([0-9]+)/, '\3-\2-\1')
      end
      if (!params[:date2].blank?) && (params[:date2].to_s.strip != "")
        filter_str << "DATE(created_at) <= ? AND "
        filter_arr << params[:date2].gsub(/([0-9]+)\.([[0-9]+)\.([0-9]+)/, '\3-\2-\1')
      end
      if (!params[:status].blank?) && (params[:status].to_s.strip != "")
        filter_str << "status = ? AND "
        filter_arr << params[:status]
      end
      filter_str << "1=1"
    end
    @items = Order.items_page(params[:page], [filter_str] + filter_arr)
  end
  
  def options
    @page_title = "Настройка уведомлений"
  end
  
  def delete
    render :update do |page|
      @item = Order.find_by_id(params[:id])
      if !@item.blank?
        @item.destroy
        render :text => ""
      else
        render :text => ""
      end
    end
  end
  
  def update
    @item = Order.find_by_id(params[:id])
    render :update do |page|
      old_status = @item.status
      if !@item.blank?
        if @item.update_attributes({:status => params[:status]})
          #page << "$('#order_dates_#{@item.id}').html('#{order_dates(@item)}');"
          #@item.create_notifies(@item.status)
          if old_status != @item.status
 #           begin
              Mailer.deliver_order_status(@item, @item.sender_email)
#            rescue Exception => exc
  #             page << "alert(\"#{exc.message}\");"
   #            page << exc.backtrace.join("\n")
    #           puts exc.message
     #          puts exc.backtrace.join("\n")
          #  end
          end
        end
        page.replace_html("order_status_#{@item.id}", order_status(@item))
      else
        page << "alert(\"Can't find item.\");";
      end
    end
  end
end
