class AdminReviewsController < ApplicationController
  layout "admin"
  include Admin
  
  before_filter :init_tabs
  helper_method :model_title
  
  def model_title
    {:many => "отзывы", :one => "отзыв", :what => "отзыв", :list => "отзывов"}
  end


  def model_name
    Review
  end
  
  
  def init_tabs
    @tabs = [["Добавить #{model_title[:what]}", "/#{params[:controller]}/new"], ["Список #{model_title[:list]}", "/#{params[:controller]}/list/"]]  
    if params[:action] == "edit"
      @tabs = [["Редактировать #{model_title[:what]}", "/#{params[:controller]}/edit/#{params[:id]}"]] + @tabs
    end
  end

end
