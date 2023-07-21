#include ActionView::Helpers::FormOptionsHelper
#include ActionView::Helpers::NumberHelper
include ProductsHelper
include TranslateHelper

class FlowersController < ApplicationController
  layout "main"
  
  def index
    @page_title = translate("flowers_title")
  end
  
  def create_bouquet
    if request.post?
      pack = BouquetPack.find_by_id(params[:pack])
      if (!params[:quantity].blank?) && (!params[:flower].blank?) && (!pack.blank?)
        b = Bouquet.new({:bouquet_pack_id => pack.id})
        b.save
        name = "#{translate("bouquet")}: "
        total_price = 0
        puts name
        for key in params[:flower].keys
          flower = Flower.find_by_id(params[:flower][key])
          if (!flower.blank?) && (!flower.flower_name.blank?)
            bi =BouquetItem.new({:bouquet_id => b.id, :quantity => params[:quantity][key], :flower_id => flower.id})
            bi.save
            bi.price = bi.quantity * flower.price
            bi.save
            total_price = total_price + bi.price
            name = "#{name}#{translate_name(flower.flower_name.name)} #{translate_name(flower.color)} - #{bi.quantity} #{translate("bouquet_shtuk")}. (#{show_amount(bi.price)}), "
            puts name
          end
        end
        puts name
        b.name = "#{name} #{translate("bouquet_pack")}: #{translate_name(pack.name)} (#{show_amount(pack.price)})"
        puts b.name
        b.price = total_price + pack.price
        b.save
        @cart.add_product(b)
      end
    end
   redirect_to "/cart"
  end
  
  def colors
    @flower = FlowerName.find_by_id(params[:id])
    if @flower.blank?
      render :text => ""
    else
      render :layout => false
    end
  end
end
