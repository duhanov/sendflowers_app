require 'mechanize'
require 'nokogiri'
require "digest"
require 'iconv'

include ApplicationHelper

class MechanizeEncodingHook
  
  
  def win1251toUTF8(s)
    ic = Iconv.new('UTF-8','WINDOWS-1251')
    ic.iconv(s)
  end
  
  
  def call(params)
    return if params[:response].nil? || params[:response_body].nil?
    response      = params[:response]
    content_type  = response['Content-Type']
    if content_type =~ /windows\-1251/
      internal_encoding = "utf-8"
      charset = 'windows-1251'
      content_type = content_type.sub(/charset=.*/, "charset=#{internal_encoding}")
      response['Content-Type'] = content_type
      params[:response_body]= win1251toUTF8(params[:response_body]).gsub(/<HEAD>(.*)WINDOWS\-1251(.*)<\/HEAD>/im, "<HEAD>\\1UTF-8\\2</HEAD>")
      #puts params[:response_body]
    end
  end
end

class EasypayController < ApplicationController
  layout "main"
  
  helper_method :UTF8towin1251

  def UTF8towin1251(s)
    ic = Iconv.new('WINDOWS-1251', 'UTF-8')
    ic.iconv(s)
  end


  def notify
    @order =Order.find_by_id(params[:order_mer_code])
    if !@order.blank?
      #notify_signature = md5 (order_mer_code . sum . mer_no . card . purch_date . web_key)
      to_md5 = @order.id.to_s + (@order.total_price_rub.to_i + @order.delivery_price_rub.to_i).to_s + trans_option("easypay_mer_no") + params[:card] + params[:purch_date] + trans_option("easypay_web_key") 
      notify_signature = Digest::MD5.hexdigest(to_md5)
      if notify_signature == params[:notify_signature]
        @order.status ="payed"
        @order.payed_from = "Easypay: #{params[:card]} #{params[:purch_date]} #{params[:sum]}руб."
        @order.save
        Syslog.add("Easypay ##{@order.id}", "Заказ оплачен.")
      else
        params[:real_signature] = notify_signature
        Syslog.add_error("Easypay ##{@order.id}", "Ошибка в notify_signature.", params.inspect)        
      end
    end
    render :text => params.inspect
  end
  
  def ok
    @order = Order.find_by_id(params[:id])
    if @order.blank?
      redirect_to "/"
    else
      @page_title = translate("payment_complete")
    end
  end
  
  def cancel
    @order = Order.find_by_id(params[:id])
    if @order.blank?
      redirect_to "/"
    else
      flash[:error] = translate("pay_via_easypay_error")
      redirect_to "/easypay/index/#{@order.id}"
    end    
  end
  
  def index
    @agent = WWW::Mechanize.new{ |agent| 
      agent.history.max_size = 10 
      agent.user_agent_alias = 'Mac Safari'
    }
    @agent.post_connect_hooks << MechanizeEncodingHook.new
    
    @page_title = translate("pay_via_easypay")
    @order = Order.find_by_id(params[:id])
    if @order.blank?
      flash[:error] = translate("order_not_found")
      redirect_to "/"
    else
      @to_md5 = trans_option("easypay_mer_no") + trans_option("easypay_web_key") + @order.id.to_s + (@order.total_price_rub.to_i + @order.delivery_price_rub.to_i).to_s
      @EP_Hash = Digest::MD5.hexdigest(@to_md5)
      @EP_Comment =  "Оплата заказа в магазине #{trans_option("site_name")}" #.parameterize
      @EP_Comment = Russian.transliterate("Заказ №#{@order.id}. Оплата за товар. Получатель платежа: «#{request.host}»")

      @EP_OrderInfo =  "Оплата товаров" #.parameterize
      @EP_OrderInfo =  Russian.transliterate("Оплата товаров") #.parameterize
      
      if request.post?
        if trans_option("easypay_test_mode") == "1"
          url = "https://ssl.easypay.by/test/test.wsdl"
        else
          url = "https://ssl.easypay.by/xml/easypay.wsdl"
        end
        if params[:card] !~ /^[0-9]{8}$/
          flash[:error] = "Идентификатор электронного кошелька EasyPay должен состоять из 8 цифр."
        else
          comment = "Оплата счёта ##{@order.id} в магазине #{trans_option("site_name")}"
          info = ""
          more_xml = ""
          req = "<?xml version=\"1.0\" encoding=\"utf-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://easypay.by/\"><SOAP-ENV:Body><ns1:EP_CreateInvoice><ns1:mer_no>#{trans_option("easypay_mer_no")}</ns1:mer_no><ns1:pass>#{trans_option("easypay_mer_pass")}</ns1:pass><ns1:order>#{@order.id}</ns1:order><ns1:sum>#{(@order.total_price_rub.to_i + @order.delivery_price_rub.to_i)}</ns1:sum><ns1:exp>7</ns1:exp><ns1:card>#{params[:card]}</ns1:card><ns1:comment>#{comment}</ns1:comment><ns1:info>#{info}</ns1:info><ns1:xml>#{more_xml}</ns1:xml></ns1:EP_CreateInvoice></SOAP-ENV:Body></SOAP-ENV:Envelope>"
          puts url
         # render :text => req
          @postdata = req#URI.escape(req)
          @page = @agent.post(url, @postdata, 'Content-Type' => 'application/xml')
          render :text => @page.body
        end
      end
    end
  end
end
