class AdminGreetingTextsController < ApplicationController
	layout "admin"

	include Admin

	def model_name
		GreetingText
	end

	helper_method :model_title
	def model_title
    	{:many => "поздравления", :one => "поздравление", :what => "поздравление", :list => "поздравлений"}
	end

	before_filter :init_tabs

	def init_tabs
		@tabs = [["Категории поздравлений", "/admin_greeting_text_categories/list"]]
	end

	def edit
		@item = model_name.find_by_id(params[:id])
		if @item.blank?
			flash[:error] = "Поздравление не найдено."
			redirect_to "/admin_greeting_texts/list"
		elsif @item.greeting_text_category.blank?
			flash[:error] = "Категория не найдена."
			redirect_to "/admin_greeting_text_categories/list"
		else
			@category = @item.greeting_text_category
			@page_title = "Редактирование поздравления"
			@tabs = [["Редактирование поздравления", "/admin_greeting_texts/edit/#{@item.id}"], ["Поздравления категории #{@category.name}", "/admin_greeting_texts/list/#{@category.id}"], ["Категории поздравлений", "/admin_greeting_text_categories/list"]]
			if request.post?
				if @item.update_attributes(params[:item])
					flash[:notice] = "Поздравление отредактировано"
					redirect_to "/admin_greeting_texts/edit/#{@item.id}"
				end
			end
		end
	end

	def new
		@category = GreetingTextCategory.find_by_id(params[:id])
		if @category.blank?
			flash[:error] = "Категория не найдена."
			redirect_to "/admin_greeting_text_categories/list"
		else
			@page_title = "Добавить поздравление"
			@tabs = [["Добавить поздравление", "/admin_greeting_texts/new/#{@category.id}"], ["Поздравления категории #{@category.name}", "/admin_greeting_texts/list/#{@category.id}"], ["Категории поздравлений", "/admin_greeting_text_categories/list"]]
			@item = model_name.new
			if request.post?
				@item = model_name.new(params[:item])
				@item.greeting_text_category_id = @category.id
				if @item.save
					flash[:notice] = "Поздравление добавлено."
					redirect_to "/admin_greeting_texts/list/#{@category.id}"
				end
			end
		end
	end

	def list
		@category = GreetingTextCategory.find_by_id(params[:id])
		if @category.blank?
			flash[:error] = "Категория не найдена."
			redirect_to "/admin_greeting_text_categories/list"
		else
			@page_title = "Поздравления категории #{@category.name}"
			@tabs = [["Добавить поздравление", "/admin_greeting_texts/new/#{@category.id}"], [@page_title, "/admin_greeting_texts/list/#{@category.id}"], ["Категории поздравлений", "/admin_greeting_text_categories/list"]]
			@items = model_name.items_page(params[:page], ["greeting_text_category_id = ?", @category.id])
		end
	end

end
