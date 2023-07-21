class ProductSweeper < ActionController::Caching::Sweeper
  observe Product
  
  def after_destroy(el)
    expire_cache(el)
  end

  def after_save(el)
    expire_cache(el)
  end
  
  def expire_cache(el)
    expire_fragment("products_special")
    expire_fragment("product_#{el.id}")
    #Уничтожаем вывод категорий
    for category in el.categories
      expire_fragment(/products\_category\_#{category.id}\_.*/)
    end
    #Уничтожаем страницы с выводом отфильтрованных товаров
    expire_fragment(/products\_filters\_.*/)    
  end

end