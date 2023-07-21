class AdminFlowersController < ApplicationController
  layout "admin"
  
  include Admin
  
  before_filter :init_tabs
  
  def model_name

    FlowerName    
  end

  helper_method :model_title
  
  def model_title
    {:many => "цветов", :one => "товар", :what => "цветок", :list => "товаров"}
  end
  
  def init_tabs
    @tabs = [["Виды цветов", "/#{params[:controller]}/list"], ["Виды упаковок", "/#{params[:controller]}/packs"]]
    if params[:action] == "colors"
      @flower = FlowerName.find_by_id(params[:id])
      if @flower.blank?
        flash[:error] = "Цветок не найден."
        redirect_to "/admin_flowers/list"
      else
        @tabs = [["#{@flower.name} - Цвета", "/admin_flowers/colors/#{params[:id]}"]] + @tabs      
      end
    end
    return true
  end
  
  
  def packs
    @page_title = "Виды упаковок"
    @items = BouquetPack.find(:all, :order => "name")
  end
  
  def colors
    @page_title = "#{@flower.name} - Цвета"    
  end


  def delete_pack
    item = BouquetPack.find_by_id(params[:id])
    if !item.blank?
      item.destroy
    end
    render :text => ""
  end
  
  def delete_color
    flower = Flower.find_by_id(params[:id])
    if !flower.blank?
      flower.destroy
    end
    render :text => ""
  end
 
  def update_pack
    @item = BouquetPack.find_by_id(params[:id])
    if !@item.blank?
      #if ["name", "price1", "price2", "price3", "is_custom", "body"].include?(params[:field])
      if true==true
        attrs = {params[:field] => params[:update_value]}
        if @item.update_attributes(attrs)
          if params[:field] == "is_custom"
            render :text => show_yesno(params[:update_value])
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
  
  def update_color
    @item = Flower.find_by_id(params[:id])
    if !@item.blank?
      #if ["name", "price1", "price2", "price3", "is_custom", "body"].include?(params[:field])
      if true==true
        attrs = {params[:field] => params[:update_value]}
        if @item.update_attributes(attrs)
          if params[:field] == "is_custom"
            render :text => show_yesno(params[:update_value])
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
  
  def list
    @page_title = "Цветы и букеты"
    @items = FlowerName.find(:all, :order => "name")
  end

  def add_packs
    if request.post?
      for name in params[:names].split("\n")
        name = name.gsub("\n","").gsub("\r","").strip
        if name != ""
          BouquetPack.new({:name => name}).save
        end
      end
      flash[:notice] = "Упаковки добавлены."
    end
    redirect_to "/#{params[:controller]}/packs"
  end
  
  
  def add_colors
    if request.post?
      for name in params[:names].split("\n")
        name = name.gsub("\n","").gsub("\r","").strip
        if name != ""
          Flower.new({:color => name, :flower_name_id => params[:id]}).save
        end
      end
      flash[:notice] = "Цвета добавлены."
    end
    redirect_to "/#{params[:controller]}/colors/#{params[:id]}"
  end
  
  def add
    if request.post?
      for name in params[:names].split("\n")
        name = name.gsub("\n","").gsub("\r","").strip
        if name != ""
          FlowerName.new({:name => name}).save
        end
      end
      flash[:notice] = "Названия цветов добавлены."
    end
    redirect_to "/#{params[:controller]}/list"
  end
  
  def model_name2
    Flower
  end
  
  def model_name_title
    "Flower"
  end
  
  def update_product_image
    responds_to_parent do
    render :update do |page|
      @item = model_name2.find_by_id(params[:id])
      if !@item.blank?
        if @item.update_attributes(params[:product])
          page << "complete_product_image_upload(#{@item.id}, '#{@item.image.url(:thumb)}');"
        else
          page << "cancel_product_image_upload(#{@item.id});"
        end
      else
        page << "cancel_product_image_upload(#{params[:id]});"
      end
    end
    end
  end
  

  def product_images
    @item = model_name2.find_by_id(params[:id])
    if @item.blank?
      render :text => "Не удалось найти запись"
    else
      @items = @item.images              
#      render :layout => false
      render :partial => "widgets_admin/product_images"
    end
  end
  
  def images_list
    @item = model_name2.find_by_id(params[:id])    
    if @item.blank?
      render :text => "Не удалось найти запись."      
    else
      @items = @item.images
      render :partial => "widgets_admin/images_list"
    end
  end

  
  def model_name_title2
    "Flower"  
  end
  
  def upload_image
    @product = model_name2.find_by_id(params[:id])
    if @product.blank?
#      puts "Can't find Product for upload Image."
      render :text => "Can't find Product for upload Image."
    else
      @item = Image.new(params[:product_image])
      @item.image_owner_type = model_name_title2
      @item.image_owner_id = @product.id 
      if @item.save
        render :text => "Uploaded"
      else
#        puts @item.errors.inspect
        render :text => @item.errors.inspect
      end
    end    
  end
  
  def sort_images
    p = 0
    for id in params[:item]
      item = Image.find_by_id(id)
      if !item.blank?
        item.p = p
        if item.save
          if item.p == 0
            first_image = item
          end
        end
      end
      p = p + 1
    end
    render :update do |page|
      if !first_image.blank?
        page << "$('#product_image_#{first_image.image_owner_id}').attr('src', '#{first_image.image.url(:thumb)}');"        
      end
    end
  end
  
  def delete_image
    @item = Image.find_by_id(params[:id])
    if @item.blank?
     # puts "Can't find image."
      render :text => ""
    else
      @product = model_name2.find_by_id(@item.image_owner_id)
      @item.destroy
      if @product.blank?
        #puts "Can't find product."
        render :text => ""
      else
        render :update do |page|
          page << "$('#product_image_#{@product.id}').attr('src', '#{product_image(@product, :thumb)}');"        
          page << "$('#gallery_big').attr('src', '#{product_image(@product, :big)}');"        
        end
      end
    end

  end
  def product_image(item, _class = "thumb")
    if item.image.blank?
      return "/images/thumb/missing.png"
    else
      return item.image.url(_class)
    end
  end

  
end
