class AdminGreetingTextCategoriesController < ApplicationController
	layout "admin"

	include Admin

	def model_name
		GreetingTextCategory
	end

def new
	if request.post?
		@item = model_name.new(params[:item])
		if @item.save
			flash[:notice] = "Категория добавлена"
		else
			flash[:error] = "Укажите название"
		end
	end
			redirect_to "/admin_greeting_text_categories/list"
end

  def model_title
    {:many => "категорий поздравлений", :one => "категория поздравлений", :what => "категорию поздравлений", :list => "категорий поздравлений"}
  end

	before_filter :init_tabs

	def init_tabs
		@tabs = [["Категории поздравлений", "/admin_greeting_text_categories/list"]]
	end

	def list
		@page_title = "Категории поздравлений"
		@items_ru = GreetingTextCategory.find(:all, :order => "p", :conditions => ["language = ?", 'ru'])
		@items_en = GreetingTextCategory.find(:all, :order => "p", :conditions => ["language = ?", 'en'])
	end
end
