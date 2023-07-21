# -*- encoding : utf-8 -*-
#Шаблоны различных бланков сайта
class AdminFormTemplatesController < ApplicationController
	layout "admin"

	#Возможные варианты шаблонов
	helper_method :templates_names
	def templates_names
		[["Инвоис заказа", "order_invoice"], ["Письмо с заказом клиенту", "order_mail_client"], ["Письмо с заказом менеджеру", "order_mail_manager"]]
	end

	def index
		@page_title = "Шаблоны бланков"
		@items = FormTemplate.find(:all, :order => "title")
		@item = FormTemplate.new
		@way = [["Шаблоны бланков", "/admin_form_templates/index"]]
	end

	def new
		@page_title = "Новый шаблон"
		@way = [["Шаблоны бланков", "/admin_form_templates/index"], [@page_title]]
		@item = FormTemplate.new
		if request.post?
			@item = FormTemplate.new(params[:item])
			@item.site_id = @site.id
			if @item.save
				flash[:notice] = "Шаблон создан"
				redirect_to "/admin_form_templates/index"
			end
		end
	end


	def show
		@item = FormTemplate.find_by_id(params[:id])
		if @item.blank? 
			render :text => ""
		else
			render :text => @item.body.to_s
		end
	end

	def edit
		@page_title = "Редактирование шаблона"
		@way = [["Шаблоны бланков", "/admin_form_templates/index"], [@page_title]]
		@item = FormTemplate.find_by_id(params[:id])
		if @item.blank?
			redirect_to "/admin_form_templates/index"
		else
			if request.post?
				if @item.update_attributes(params[:item])
					flash[:notice] = "Шаблон отредактирован."
					redirect_to "/admin_form_templates/edit/#{@item.id}?order_id=#{params[:order_id]}"
				end
			end
		end
	end

	def delete
		if !@item.blank? && @item.site_id == @site.id
			@item.destroy
		end
		render :text => ""
	end
end
