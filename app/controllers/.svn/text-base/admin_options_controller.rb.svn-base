class AdminOptionsController < ApplicationController
  layout "admin"

  def update
    @item = Option.find_by_name(params[:name])    
    if !@item.blank?
#      if ["name", "active"].include?(params[:field])
        if @item.update_attributes({:value => params[:update_value]})
          render :text => @item.value         
        else
          render :text => "Can't update item"
        end
      #else
      #  render :text => "Не известное поле #{params[:field]}"        
      #end
    else
      render :text => "Не удалось найти запись"
    end
  end

  
  #Настройки сайта
  def list
    @page_title = "Настройки"
    if request.post?
      Option.clearOptions
      options_keys = params[:option].keys
      for key in options_keys
        option = Option.find(:first, :conditions => ["name = ?", key])
        if !option.blank?
          option.update_attributes(params[:option][key])
          #option.value = params[:option][key]
          #option.save
        end
      end
      flash[:notice] = "Настройки изменены"
      if !params[:back].blank?
        redirect_to params[:back]
      else
        redirect_tab "/admin_options/list"        
      end
    end
    #@options = Option.find(:all)    
  end

    
end
