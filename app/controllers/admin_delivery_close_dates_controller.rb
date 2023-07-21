class AdminDeliveryCloseDatesController < ApplicationController
	layout "admin"
	include Admin

	before_filter :init_tabs

	helper_method :model_title


  #Inplace Editor
  def update
    @item = model_name.find_by_id(params[:id])
    if !@item.blank?
      #if ["name", "price1", "price2", "price3", "is_custom", "body"].include?(params[:field])
      if true==true
        attrs = {params[:field] => params[:update_value]}
        if @item.update_attributes(attrs)
          if ["is_custom", "active", "enable"].include?(params[:field])
            render :text => show_yesno(params[:update_value])
          elsif params[:field] == "month"
			if @months.find{|i| i[1].to_i == @item.month}.blank?
				render :text => @item.month
			else
				render :text => @months.find{|i| i[1].to_i == @item.month}[0]
			end
          elsif params[:field] == "year"
			if @years.find{|i| i[1].to_i == @item.year}.blank?
				render :text => @item.year
			else
				render :text => @years.find{|i| i[1].to_i == @item.year}[0]
			end
          else
            render :text => params[:update_value]          
          end
        else
          render :text => "Can't update item"
        end
      else
        render :text => "Не известное поле #{params[:field]}"        
      end
    else
      render :text => "Не удалось найти запись"
    end
  end


	def init_tabs
		@months = [["Январь", "1"], ["Февраль", "2"], ["Март", "3"], ["Апрель", "4"], ["Май", "5"], ["Июнь", "6"], ["Июль", "7"], ["Август", "8"], ["Сентябрь", "9"], ["Октябрь", "10"], ["Ноябрь", "11"], ["Декабрь", "12"]]
		@years = [["Любой", 0]] + ((DateTime.now.year-2)..(DateTime.now.year + 10)).to_a.map{|i| [i, i]}
		@days = (1..31).to_a.map{|i| [i,i]}

	    @tabs = [["Виды доставок", "/admin_deliveries/list"], ["Закрытые даты", "/admin_delivery_close_dates/index"]]
	end

	def add
		@item = model_name.new(params[:item])
		if @item.save
			#flash[:notice] = "Дата добавлена"			
		end
		render :text => "added"
#		redirect_to "/#{params[:controller]}/list"
	end


	def model_name
		DeliveryCloseDate
	end

	def model_title
		{}
	end

	def list
		@items = model_name.find(:all, :order => "year, month, day", :conditions => ["language = ?", params[:id]])
		render :layout => false
	end

	def index
		@page_title = "Закрытые даты для доставок"
		render :layout => false
	end

end
