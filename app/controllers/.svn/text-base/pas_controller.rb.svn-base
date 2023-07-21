require 'mechanize'

class PasController < ApplicationController


	layout "main"

	def index
		session[:return_to] ||= request.referer 
		@order = Order.find(params[:id])
	  #@order.order_status_num = 7
	  #@order.save
	end

	def ok
		@order = Order.find(params[:id])
		@agent = WWW::Mechanize.new{ |agent| 
		        agent.history.max_size = 10 
		        agent.user_agent_alias = 'Mac Safari'
		      }
		postdata = {"Ordernumber" => @order.id, "Merchant_ID" => "611889" ,"Login" => Option.get('pas_login') ,"Password" => Option.get('pas_password'), "Format" => "3" }
		res = @agent.post("https://pay112.paysec.by/orderstate/orderstate.cfm", postdata)
		res = Hash.from_xml(res.body)
		values = res["result"]["order"]
		if !values.blank?
	          	if values["orderamount"].to_f < @order.total_price.to_f + @order.delivery_price.to_f
	            	Syslog.add_error("Payband ##{@order.id}", "Сумма оплаты надостаточна (#{values["orderamount"].to_f} < #{(@order.total_price.to_f + @order.delivery_price.to_f)})")
	        else
    	        @order.status ="payed"
        	    @order.save
            	Syslog.add("Payband ##{@order.id}", "Заказ оплачен.")
          	end
#			if values["orderamount"].to_f == @order.total_price.to_f && values["ordernumber"].to_s == @order.id.to_s && values["ordercurrency"].to_s == "USD" && values["orderstate"]=="Approved"
#				@order.status = 'payed'
#				@order.save
#				redirect_to "/order/step3/#{@order.id}"
#				return
#			else
				#не оплачен
#			end
		end		

      @page_title = translate("payment_complete")

   		#redirect_to "/order/complete/#{@order.id}"

	end

	def no
      flash[:error] = translate("pay_via_easypay_error")
      redirect_to "/payband/index/#{@order.id}"
	end

end
