class OrderItem < ActiveRecord::Base
  belongs_to :order
  attr :product
  
  def before_save
    if self.price_rub.blank? || (self.price_rub == 0)
      self.price_rub = self.price.to_f * Option.get("kurs_usd").to_f   
    end
  end
  
  def product
    if @product.blank?
      if self.product_type == "Bouquet"
        @product = Bouquet.find_by_id(self.product_id)
      else
        @product= Product.find_by_id(self.product_id)
      end
    end
    @product
  end
end
