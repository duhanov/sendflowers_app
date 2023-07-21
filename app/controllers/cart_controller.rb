include ProductsHelper
#include ActionView::Helpers::NumberHelper

class CartController < ApplicationController
  layout "main"
  
#  def index
 #   render :partial => "cart"
 # end


  def product_model
    if params[:type].blank? || params[:type] == "Product"
      return Product  
    elsif params[:type] == "Toy"
      return Toy
    end
  end
  
  def update_quantity
    #@product = Product.find(:first, :conditions => ["id = ?", params[:id]])
    if params[:type] == "Bouquet"
      @product = Bouquet.find_by_id(params[:id])    
    else
      @product = product_model.find_by_id(params[:id])    
    end
 
    render :update do |page|
      if !@product.blank?
        if !@cart.in_cart(@product)
          @cart.add_product(@product)
        end
        @cart.set_quantity(@product, params[:quantity].to_i)
      end
      page << "$('#cart_total_no_delivery').val('#{get_amount(@cart.price)}');"
      #page << "$('#cart_item_price_show_#{@product.id}').html('#{show_amount(@product.producer_price.to_i*params[:quantity].to_i)}');"
      page << "$('#cart_item_price_#{@product.id}').html('#{(show_amount(@product.price.to_f*params[:quantity].to_i.to_f))}');"
      page.replace_html("cart_mini", render(:partial => "cart/mini"))
      #page << "$('#cart_total').html('#{show_amount(@cart.price)}');"
#      page.replace_html("mini_cart", render(:partial => "cart/mini"))
      page << "calcTotalCart();"
    end

  end

  def delete
    if params[:type] == "Bouquet"
      @product = Bouquet.find_by_id(params[:id])    
    else
      @product = product_model.find_by_id(params[:id])    
    end
    if !@product.blank?
      @cart.delete_product(@product)
      if params[:type] == "Bouquet"
        @product.destroy
      end
    end
    render :update do |page|
      page << "$('#cart_total_no_delivery').val('#{get_amount(@cart.price)}');"
      page.replace_html("cart_mini", render(:partial => "cart/mini"))
      page << "calcTotalCart();"
      #page << "$('#cart_total').html('#{show_amount(@cart.price)}');"
    end
  end

  def mini_cart
    render :partial => "cart/mini"  
  end
  
  def add
    @cart = find_cart
 #   @cart = Cart.new
    @product = product_model.find_by_id(params[:id])
    if !@product.blank?
      @cart.add_product(@product)
      if !params[:quantity].blank?
        @cart.set_quantity(@product, params[:quantity].to_i)
      end
    end
    #render :partial => "cart"
    redirect_to "/cart/index"
    #cart    
  end


  def index
    @page_title = translate "cart_title"
    #Формируем список специальных предлжений
    special_categories_ids = []
    for item in @cart.items
      if !item.product.blank? && (item.product.type.to_s == "Product")
       for category in item.product.categories
          special_categories_ids << category.id
        end
      end
    end
    special_categories_ids.uniq!
   # render :text => special_categories_ids.inspect
    #if special_categories_ids.blank?
      @cart_specials = []
    #else
      #@cart_specials = Product.find(:all, :conditions => ["is_cartspecial = 1"], :joins => "INNER JOIN categories_products ON ((categories_products.product_id=products.id) and (categories_products.category_id IN(#{special_categories_ids.join(",")})))")    
      @cart_specials = Product.find(:all, :conditions => ["is_cartspecial = 1"])    
      @cart_specials.uniq!
    #end
  end
end
