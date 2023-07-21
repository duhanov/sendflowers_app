class GreetingTextsController < ApplicationController
	def categories
		@items = GreetingTextCategory.find(:all, :order => "p", :conditions => ["language = ?", params[:language]])
		render :layout => false
	end

	def category
		@category = GreetingTextCategory.find_by_id(params[:id])
		if @category.blank?
			render :text => "Категория не найдена."
		else
			@items = GreetingText.find(:all, :conditions => ["greeting_text_category_id = ?", @category.id], :order => "id DESC")
		end
		render :layout => false
	end
end
