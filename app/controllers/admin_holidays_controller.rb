class AdminHolidaysController < ApplicationController

  layout "admin"
  include Admin
  
  before_filter :init_tabs
  helper_method :model_title

  
  def model_title
    {:many => "праздники", :one => "праздник", :what => "праздник", :list => "праздников"}
  end


  def model_name
    Holiday
  end
  
  
  def init_tabs
    @tabs = [["Добавить #{model_title[:what]}", "/#{params[:controller]}/new"], ["Список #{model_title[:list]}", "/#{params[:controller]}/list/"]]  
    if params[:action] == "edit"
      @tabs = [["Редактировать #{model_title[:what]}", "/#{params[:controller]}/edit/#{params[:id]}"]] + @tabs
    end
  end
  
  
#Работа с материалами по теме

  
  def add_assigment
    @parent = model_name.find_by_id(params[:id])
    eval("@item = #{params[:assigment_type].capitalize}.find_by_id(#{params[:assigment_id]})")
    if @parent.blank?
      render :text => "alert('Не удалось найти родителя.');"
    elsif @item.blank?
      render :text => "alert('Не удалось найти запись для добавления.');"
    else
      if params[:assigment_type].capitalize == @parent.type.to_s
        eval("@parent.#{params[:assigment_type]}s1 << @item")
      else
        eval("@parent.#{params[:assigment_type]}s << @item")
      end
      eval("@parent.save")
      render :text => "$('#assigments_#{params[:assigment_type]}_items').load('/#{params[:controller]}/assigment_items/#{@parent.id}?assigment_type=#{params[:assigment_type]}');"
    end
  end
  
  def delete_assigment
    @parent = model_name.find_by_id(params[:id])
    eval("@item = #{params[:assigment_type].capitalize}.find_by_id(#{params[:assigment_id]})")
    if @parent.blank?
      render :text => "alert('Не удалось найти родителя.');"
    elsif @item.blank?
      render :text => "alert('Не удалось найти запись для добавления.');"
    else
      if params[:assigment_type].capitalize == @parent.type.to_s
        eval("@parent.#{params[:assigment_type]}s1.delete(@item)")
        eval("@parent.#{params[:assigment_type]}s2.delete(@item)")
      else
        eval("@parent.#{params[:assigment_type]}s.delete(@item)")        
      end
      eval("@parent.save")
      render :text => "deleted"
    end
  end
  
  def assigment_items
    @parent = model_name.find_by_id(params[:id])
    if @parent.blank?
      render :text => "Не удалось найти родителя."
    else
      @items = eval("@parent.#{params[:assigment_type]}s")
      @item = @parent
      render :partial => "admin/assigments_items", :locals => {:items => @items, :name => params[:assigment_type]}
    end
  end
  
  def assigments_for_add
    @parent = model_name.find_by_id(params[:id])
    if @parent.blank?
      render :text => "Запись не найдена."
    else
      @items = eval("#{params[:assigment_type].capitalize}.find(:all, :order => 'name')")
      @assigments = eval("@parent.#{params[:assigment_type]}s")
      if params[:assigment_type].capitalize == @parent.type.to_s
        @items.delete(@parent)
      end
      for item in @items
        if @assigments.include?(item)
          @items.delete(item)
        end
      end
      render :partial => "admin/assigments_for_add"
    end
  end
  
end
