class CartItem
  attr_reader :product, :quantity
  
  def initialize(product)
    @product = product
    @quantity = 1 
  end
  
  def increment_quantity
    @quantity += 1
  end
  
  def set_quantity(q)
    @quantity = q
  end
  
 
  def title 
      #@product.group.name
#    @product.product.name
    return @product.name
  end
  
  def price
    @product.price.to_f * @quantity.to_i.to_f
   # @product.price_rozn * @quantity    
  end
  
  def price_usd
    
  end

# def price_related_on_main_currency
  #  product_price = self.price
   # 
   # if @product.currency == Currency.main
   #   product_price
   # else
   #   product_price*(@product.currency.converter/Currency.main.converter)
   # end    

  #end
  
  def product
    @product
  end
  
end