class CategorySweeper < ActionController::Caching::Sweeper
  observe Category
  
  def after_destroy(el)
    expire_cache(el)
  end

  def after_save(el)
    expire_cache(el)
  end
  
  def expire_cache(el)
    expire_fragment("menu_categories")
    expire_fragment(/products\_category\_#{el.id}\_.*/)
  end
  
end