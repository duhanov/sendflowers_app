module CatalogHelper
  
  def link2category(category)
    "/catalog/category/#{category.id}"
  end
  
  def product_body(product)
    if @language == "ru"
      return product.body
    else
      return product.body_en
    end
  end
  
  def category_name(product)
    if @language == "ru"
      return product.name
    else
      return product.name_en
    end    
  end

  def product_name(product)
    if product.type.to_s == "Bouquet"
      return translate_name(product.name)
    else
      if @language == "ru"
        return product.name
      else
        return product.name_en
      end    
    end
  end
  
  def product_description(product)
    if product.type.to_s == "Bouquet"
      translate_name(product.description)
    else
      if @language == "ru"
        return product.description
      else
        return product.description_en
      end    
    end
  end
  
  def add2cart(product)
    "/#{@language}/cart/add/#{product.id}"  
  end
  
  def link2product(product)
    "/#{@language}/catalog/product/#{product.id}"
  end
  
  def products_on_page_default
    16  
  end
  
  def products_show_all
    !params[:show_all].blank?
  end
  
  def products_on_page
    if params[:show_all].blank?
      return products_on_page_default
    else
      return 10000
    end
  end
end
