require "digest"
require 'mechanize'
include AdminOrdersHelper
include OrderHelper
include CatalogHelper
include ApplicationHelper

class OrderController < ApplicationController
  layout "main"
  
  def history
    if current_user.blank?
      redirect_to "/"
    else
      @items = Order.find(:all, :conditions => ["user_id = ?", current_user.id], :order => "id DESC")
    end
  end



  def get_close_date(date)
    DeliveryCloseDate.find(:first, :conditions => ["day = ? AND month = ? AND (year = 0 OR year = ?)", date.day, date.month, date.year])
  end

  def is_close_date(date)
    if !session[:order].blank? && !session[:order].delivery.blank? && !Delivery.find_by_id(session[:order].delivery_id).blank? && Delivery.find_by_id(session[:order].delivery_id).is_main_delivery
      l = "main"
    else
      l = "other"
    end

    d = DeliveryCloseDate.find(:first, :conditions => ["day = ? AND month = ? AND (year = 0 OR year = ?) AND language = ?", date.day, date.month, date.year, l])
    if !d.blank? || date.to_date < DateTime.now.to_date  ||  (date.year == DateTime.now.year && date.month && DateTime.now.month && date.day == DateTime.now.day && DateTime.now.hour*60 +DateTime.now.min >= Option.get('delivery_end_hour').to_i * 60 + Option.get('delivery_end_minute').to_i)
      return true
    else
      return false
    end
  end

  #Проверка на закрытую дату доставку и 
  def check_close_date
    if params[:id] =~ /^([0-9]+)\-([0-9]+)\-([0-9]+)$/
      d = "#$3"
      m = "#$2"
      y = "#$1"
      date = Date.strptime(params[:id], '%Y-%m-%d')
      #@close_date = get_close_date(date)
      #Ищим ближайщую свободгую дату
      if is_close_date(date)
        @next_date = date + 1.day
        while is_close_date(@next_date)
          @next_date = @next_date + 1.day
        end
      end
      render :layout => false
    else
      render :text => "Unknow date format"
    end
  end
  
  def status
    @cart = find_cart
    @order = order_from_session
    if @order.blank?
      @order = Order.new
    end
    @page_title = "Статус заказа"
    
    if request.post?
      order = Order.find_by_id(params[:order][:id])
      if order.blank?
        flash[:error] = translate "order_not_found"
      elsif order.email != params[:order][:sender_email]
        flash[:error] = translate("invalid_email")# #{order.email} != #{params[:order][:email]}"
      else
        flash[:notice] = translate("get_order_status").gsub("id", "##{order.id}").gsub("orderstatus", "<b>#{order_status_title(order)}</b>")
      end
      redirect_to "/order/status"
    end
  end
  
  def order_from_session
    if !session[:order].blank?
      session[:order].errors.clear
      session[:order].set_defaults
    end
    session[:order]
  end
  
  def paymentmethod
    @page_title = translate "order_payment_method"
    @order = order_from_session
#    render :text => @order.delivery_id
    if !session[:telephone].blank?
      @telephone = session[:telephone]
    else
      @telephone = []
    end
    @order.step = 2
    if @order.blank?
      redirect_to "/order/index"
    elsif request.post?
      @order = Order.new(params[:order])
      @order.step = 2
      session[:order] = @order

      if @order.valid?
        redirect_to "/order/check"
      end
    end
  end
  
  def save_order_items
    for item in @cart.items
      oi = OrderItem.new({:order_id => @order.id, :product_type => item.product.type.to_s, :product_id => item.product.id, :price => item.price, :quantity => item.quantity})
      oi.save
    end    
  end
  
  def mail_order
      @mail_error = ""
        begin
          Mailer.deliver_new_order(@order, Option.get("order_email_to"), @language);
        rescue Exception => exc
#          @mail_error << "ERROR1:#{exc.message}, "
        end
        begin
          Mailer.deliver_new_order(@order, @order.sender_email, @language);
        rescue Exception => exc
 #         @mail_error << "ERROR2:#{exc.message}, "
        end
    
  end
  
  def save_order_telephones
    for key in params[:telephone].keys
      t = OrderPhone.new(params[:telephone][key])
      t.order_id = @order.id
      t.save
    end    
  end
  
  #EasyPay
  def easypay
    @order = Order.find_by_id(params[:id])
    if @order.blank?
      flash[:error] = translate("order_not_found")
      redirect_to "/"
    else
      @page_title = translate("pay_via_easypay")
      if request.post?
        @order = Order.new(params[:order])
      end
    end
  end
  
  #Webpay
  def webpay_ok
    @order = Order.find_by_id(params[:id])
    if @order.blank?
      flash[:error] = translate("order_not_found")
      redirect_to "/"
    else
      @page_title = translate("payment_complete")   
    end
  end

  def webpay_cancel
    flash[:error] = translate("pay_via_webpay_error")  
    redirect_to "/order/webpay/#{params[:id]}"
  end
  
  def webpay_notify
    @order = Order.find_by_id(params[:site_order_id])
    if @order.blank?
      Syslog.add_error("Webpay ##{@order.id}", "Заказ не найден", params.inspect)  
    else
      username = trans_option('webpay_username')
      password = trans_option('webpay_password')
      if @language == "en"
        username = trans_option('webpay_username_en')
        password = trans_option('webpay_password_en')
      end

      xml_request= URI.escape("<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?><wsb_api_request><command>get_transaction</command><authorization><username>#{username}</username><password>#{password}</password></authorization><fields><transaction_id>#{params[:transaction_id]}</transaction_id></fields></wsb_api_request>")
      @postdata = "*API=&API_XML_REQUEST=#{xml_request}"
      @agent = WWW::Mechanize.new{ |agent| 
        agent.history.max_size = 10 
        agent.user_agent_alias = 'Mac Safari'
      }       
      Syslog.add("Webpay ##{@order.id}", "Проверка платежа")
      begin
        res = @agent.post("https://billing.webpay.by", @postdata)
        if res.body =~ /<status>success<\/status>/ && res.body =~ /<currency_id>BYN<\/currency_id>/ && res.body =~ /<amount>#{params[:amount]}<\/amount>/
          if params[:amount].to_f < @order.total_price_rub.to_f + @order.delivery_price_rub.to_f
            Syslog.add_error("Webpay ##{@order.id}", "Сумма оплаты надостаточна (#{params[:amount].to_f} < #{@order.total_price_rub.to_f})")
          else
            @order.status ="payed"
            @order.save
            Syslog.add("Webpay ##{@order.id}", "Заказ оплачен.")
          end
        else
          Syslog.add_error("Webpay ##{@order.id}", "Неизвестный ответ Webpay", res.body)        
        end
      rescue Exception => exc
        Syslog.add("Webpay ##{@order.id}", "Проверка платежа провалилась: #{exc.message}", params[:inspect])
      end
    end
    render :text => ""
  end

  def webpay
    if @language == "ru"
      @page_title = "Оплата заказа через Webpay"
    else
      @page_title = "Pay via Webpay"
    end
    @order = Order.find_by_id(params[:id])
    if @order.blank?
      flash[:error] = "Заказ не найден."
      redirect_to "/"
    else
      #@wsb_seed = DateTime.now.to_i
      @wsb_seed = Time.now.to_i#to_time.to_i
      @wsb_test = trans_option('webpay_wsb_test')
      if @language == "en"
        @wsb_test = trans_option('webpay_wsb_test_en')
      end
      @wsb_currency_id = "BYN"
      @skidka = 0 
      @skidka_title = ""
      store_id = trans_option('webpay_wsb_stroreid')
      store_id = trans_option('webpay_wsb_stroreid_en') if @language == "en"
      secret_key = trans_option('webpay_secretkey')
      secret_key = trans_option('webpay_secretkey_en') if @language == "en"

#$this->tv["wsb_signature"] = sha1($this->tv["wsb_seed"].$this->tv["wsb_stroreid"].$this->tv["wsb_order_num"].$this->tv["wsb_test"].$this->tv["wsb_total"].$WebPaySecretKey);
#$this->tv["wsb_signature"] = sha1($this->tv["wsb_seed"].$this->tv["wsb_stroreid"].$this->tv["wsb_order_num"].$this->tv["wsb_test"].$this->tv["wsb_currency_id"].$this->tv["wsb_total"].$WebPaySecretKey);
      @wsb_signature = Digest::SHA1.hexdigest("#{@wsb_seed}#{store_id}#{@order.id}#{@wsb_test}#{@wsb_currency_id}#{@order.total_price_rub}#{secret_key}") 
      @wsb_total = @order.total_price_rub + @order.delivery_price_rub - @skidka
    end
  end
  
  #Webmoney
  def webmoney
    @page_title = translate "pay_via_webmoney"
    @order = Order.find_by_id(params[:id])
    if @order.blank?
      flash[:error] = translate "order_not_found"
      redirect_to "/"
    else
      
    end
  end
  
  def wm_fail
    @flash[:error] = translate "pay_via_webmoney_error"
    redirect_to "/order/webmoney/#{params[:LMI_PAYMENT_NO]}"
  end
  
  def wm_success
    @page_title = translate "payment_complete" 
  end
  
  def wm_result
    @order = Order.find_by_id(params[:LMI_PAYMENT_NO])
    if @order.blank?
      Syslog.add("Webmoney", "Заказ не найден", params.inspect)
      render :text => "Order not found!"
    else
      #Если предварительный запрос
      if !params[:LMI_PREREQUEST].blank? && params[:LMI_PREREQUEST] == "1"
        Syslog.add("Webmoney ##{@order.id}", "Предварительный запрос", params.inspect)
        render :text => "PREREQUEST: #{params.inspect}"
      else
        @amount = ""
        if (params[:LMI_PAYEE_PURSE] =~ /^B.+/)
          @amount = @order.total_price_rub.to_f + @order.delivery_price_rub.to_f
          @purse = trans_option('wmb_purse')
        elsif (params[:LMI_PAYEE_PURSE] =~ /^Z.+/)
          @amount = @order.total_price.to_f + @order.delivery_price.to_f
          @purse = trans_option('wmz_purse')
        end
        if @amount == ""
          Syslog.add_error("Webmoney ##{@order.id}", "Оплата на неизвестный кошелек: #{params[:LMI_PAYEE_PURSE]}", params.inspect)
        elsif @purse != params[:LMI_PAYEE_PURSE]
          Syslog.add_error("Webmoney ##{@order.id}", "Оплата на неизвестный кошелек #{params[:LMI_PAYEE_PURSE]}, нужно на: #{@purse}", params.inspect)
        elsif @amount < params[:LMI_PAYMENT_AMOUNT].to_f
          Syslog.add_error("Webmoney ##{@order.id}", "Оплаченная сумма (#{params[:LMI_PAYMENT_AMOUNT]}) меньше требуемой (#{@amount}), на: #{@purse}", params.inspect)
        else
          @chkstring = "#{params[:LMI_PAYEE_PURSE]}#{params[:LMI_PAYMENT_AMOUNT]}#{params[:LMI_PAYMENT_NO]}#{params[:LMI_MODE]}#{params[:LMI_SYS_INVS_NO]}#{params[:LMI_SYS_TRANS_NO]}#{params[:LMI_SYS_TRANS_DATE]}#{params[:LMI_SECRET_KEY]}#{params[:LMI_PAYER_PURSE]}#{params[:LMI_PAYER_WM]}"
          @md5sum = Digest::MD5.hexdigest(@chkstring)
          if params[:LMI_HASH] != @md5sum
            Syslog.add_error("Webmoney ##{@order.id}", "Контрольная сумма не совпадает", "chkstring=#{@chkstring}<br/>md5=#{@md5sum}<br/>LMI_HASH=#{params[:LMI_HASH]}<br/>#{params.inspect}")
          else
            @order.status = "payed"
            @order.save
            Syslog.add("Webmoney ##{@order.id}", "Оплачен", params[:inspect])
          end
        end
        render :text => "Webmoney gate"
      end
    end
  end
  

  def create
    if (request.post?) && (!session[:order].blank?)
      @order = Order.new(params[:order])
      @order.ip = request.remote_ip
      @order.total_price = @cart.price
      @order.language = @language
      if !current_user.blank?
        @order.user_id = current_user.id
      end      

      if !@order.save
        render :text => "Save error"
      else
        save_order_items
        save_order_telephones
        mail_order
        flash[:mail_error] = @mail_error
        session[:cart] = nil
        session[:order] = nil
        if @order.payment_method.name.gsub(/[^a-zA-Z]+/, "").capitalize =~ /webmoney/i
          flash[:notice] = translate("order_complete_webmoney").gsub("id", @order.id.to_s)
          redirect_to "/order/webmoney/#{@order.id}"
        elsif @order.payment_method.name.gsub(/[^a-zA-Z]+/, "").capitalize =~ /easypay/i
          flash[:notice] = translate("order_complete_easypay").gsub("id", @order.id.to_s)
          redirect_to "/easypay/index/#{@order.id}"          
        elsif (@order.payment_method.name.gsub(/[^a-zA-Z]+/, "").capitalize =~ /Webpay/i) || @order.payment_method.name.gsub(/[^a-zA-Z]+/, "").capitalize =~ /КРЕДИТНАЯ КАРТА/i
          flash[:notice] = translate("order_complete_webpay").gsub("id", @order.id.to_s)
          redirect_to "/order/webpay/#{@order.id}"
        elsif (@order.payment_method.name.gsub(/[^a-zA-Z]+/, "").capitalize =~ /Payband/i) || @order.payment_method.name.gsub(/[^a-zA-Z]+/, "").capitalize =~ /Payband/i
          flash[:notice] = translate("order_complete_payband").gsub("id", @order.id.to_s)
          redirect_to "/pas/index/#{@order.id}"
        else
          flash[:notice] = translate("order_complete").gsub("id", @order.id.to_s)
          redirect_to "/order/complete/#{@order.id}"      
        end
      end
    else
      redirect_to "/"
    end
  end
  
  def set_order
    if request.post?
      session[:order] = Order.new(params[:order])
    end
    redirect_to "/order"
  end
  
  def check
    @page_title = translate "order_page_title"
    if session[:order].blank?
      redirect_to "/"
    else
      @order = session[:order]
      if !session[:telephone].blank?
        @telephone = session[:telephone]
      else
        @telephone = []
      end
      if request.post?
        
      end
    end
  end
  
  def order_from_addresses
        #Устанавливаем адрес из адресов доставки
        if !current_user.blank?
          address = UserAddress.find(:first, :conditions => ["user_id = ? AND is_main = 1", current_user.id])
          user = User.find_by_id(current_user.id)
          if !address.blank? && !user.blank?
            if @order.sender_country.to_s.strip == ""
              @order.sender_country = user.country              
            end
            if @order.organization.to_s.strip == ""
              @order.organization = address.organization              
            end
            if ["", translate("firstname")].include?(@order.firstname.to_s.strip) 
              @order.firstname = address.firstname
            end
            if ["", translate("lastname")].include?(@order.lastname.to_s.strip)
              @order.lastname = address.lastname
            end
            if ["", translate("patronymic")].include?(@order.patronymic.to_s.strip)
              @order.patronymic = address.patronymic
            end
            if ["", translate("firstname")].include?(@order.sender_firstname.to_s.strip) 
              @order.sender_firstname = user.firstname
            end
            if ["", translate("lastname")].include?(@order.sender_lastname.to_s.strip)
              @order.sender_lastname = user.lastname
            end
            if ["", translate("patronymic")].include?(@order.sender_patronymic.to_s.strip)
              @order.sender_patronymic = user.patronymic
            end
            if @order.sender_email.to_s.strip == ""
              @order.sender_email = user.email
            end
            if !user.telephones.blank?
              p = user.telephones.first
              @order.sender_telephone = "#{p.country_code} #{p.city_code} #{p.telephone}"
            end
            if @order.zip.to_s.strip == ""
              @order.zip = address.zip
            end
            if @order.city.to_s.strip == ""
              @order.city = address.city
            end
            if @order.country.to_s.strip == ""
              @order.country = address.country
            end
            if @order.address.to_s.strip == ""
              @order.address = address.address
            end
            
            if params[:telephone].blank?
              @order.telephone = address.telephone
              @order.call_time = address.call_time
              @order.city_code = address.city_code
              @order.country_code = address.country_code
            end
          end
        end
    
  end
  
  def index
    @page_title = translate "order_page_title"
    if @cart.items.blank?
      flash[:error] = "#{translate 'cart_empty'}!"
      redirect_to "/order/complete"
    elsif @cart.items.find_all{|i| (i.product.class.name == "Bouquet" || i.product.no_order_alone == false)}.size == 0
      flash[:error] = translate("no_order_alone")      
      redirect_to "/cart/index"
    else
      if !session[:order].blank?
        @order = order_from_session
        puts "order from session"
      else
        @order = Order.new        
        @order.set_defaults
      end
      order_from_addresses
      
      @order.set_defaults
      @order.step = 1
      if request.post?
        @order = Order.new(params[:order])
        @order.step = 1
        if @order.valid?
          session[:order] = @order
          session[:telephone] = params[:telephone]
          #redirect_to "/order/check"
          redirect_to "/order/paymentmethod"
        else
          @order.set_defaults
        end
        #if @item.save
        #  for item in @cart.items
        #    oi = OrderItem.new({:order_id => @item.id, :product_id => item.product.id, :price => item.price, :quantity => item.quantity})
        #    oi.save
        #  end
        #  @order = Order.find_by_id(@item.id)
        #  begin
        #    Mailer.deliver_new_order(@order, Option.get("order_email_to"));
        #  rescue
        #  end
        #  session[:cart] = nil
        #  flash[:notice] = "Ваш заказ оформлен."
        #  redirect_to "/order/complete"
        #end
      end      
    end
  end
  
  def complete
    @page_title = translate "order_page_title"
    @order = Order.find_by_id(params[:id])
  end
end
