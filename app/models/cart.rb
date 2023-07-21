class Cart
  attr_reader :items
  
  def initialize
    @items = []
  end
  
  def set_quantity(product, q)
    current_item = @items.find {|item| item.product == product}
    if current_item
      current_item.set_quantity(q)
    end
  end
  
  def delete_product(product)
#    current_item = @items.find {|item| item.product == product}
 #   if current_item
  #    current_item.destroy 
   # end 
 #   r = false;
  #  @tmp = ""
   # for i in @items
    ## if i.id == product.id
      #  r = true
       # p = product
        #@items.delete(p)
       # break
      #end
    #end
    current_item = @items.find {|item| item.product == product}
    if current_item
      @items.delete(current_item)
      return true
    else         
      return false
    end
    return r
  end
  

  
  def price
    #@items.sum {|item| item.price_related_on_main_currency}
    @items.sum {|item| item.price}
  end
  
  def total_price
    price    
  end
  
  def quantity
#    @items.sum {|item| item.quantity}
    r = 0
    for item in @items
      if (!item.product.blank?) && (!item.product.is_service)
        r = r + item.quantity        
      end
    end
    r
  end
  
  def in_cart(product)
    @items.find {|item| item.product == product}   
  end
  
  def add_product(product)
    current_item = @items.find {|item| item.product == product}
    if current_item
      current_item.increment_quantity
    else
      @items << CartItem.new(product)
    end
  end
end