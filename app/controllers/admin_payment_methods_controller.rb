class AdminPaymentMethodsController < ApplicationController
  layout "admin"
  include Admin
  
  def model_name
    PaymentMethod
  end
  
  helper_method :model_title
  
  def update_product_image
    @item = model_name.find_by_id(params[:id])
    responds_to_parent do
    render :update do |page|
      if !@item.blank?
        if @item.update_attributes(params[:product])
          page << "complete_product_image_upload(#{@item.id}, '#{@item.image.url(:original)}');"
        else
          page << "cancel_product_image_upload(#{@item.id});"
        end
      else
        page << "cancel_product_image_upload(#{params[:id]});"
      end
    end
    end
  end
  
  def list
    @page_title = "Виды оплаты"
    @items = PaymentMethod.find(:all, :order => "p")
  end

  def new
    if request.post?
      item = model_name.new(params[:item])
      if item.save
        flash[:notice] = "Вид оплаты добавлен."
      end
    end
    redirect_to "/#{params[:controller]}/list"
  end
  
  helper_method :model_title
  
  def model_title
    {:many => "видов оплаты", :one => "вид оплаты", :what => "вид оплаты", :list => "виды оплаты"}
  end
end
