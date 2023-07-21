class AdminDeliveriesController < ApplicationController
  layout "admin"
  include Admin
  
  def model_name
    Delivery
  end
  
  helper_method :model_title
  
  before_filter :init_tabs

  def index
    @page_title = "Доставка"
  end

  def init_tabs
      @tabs = [["Виды доставок", "/admin_deliveries/list"], ["Закрытые даты", "/admin_delivery_close_dates/index"]]
  end

  def list
    @page_title = "Виды доставок"
    #@items = Delivery.find(:all, :order => "p")
    render :layout => false
  end

  def times
    render :layout => false
  end

  def new
    if request.post?
      item = model_name.new(params[:item])
      if item.save
        flash[:notice] = "Вид доставки добавлен."
      end
    end
    redirect_to "/#{params[:controller]}/index"
  end
  
  def model_title
    {:many => "видов доставок", :one => "вид доставки", :what => "вид доставки", :list => "видов доставок"}
  end
end
