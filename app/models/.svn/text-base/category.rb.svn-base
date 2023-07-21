class Category < ActiveRecord::Base

  
  def full_path(language = 'ru')
    if @full_path.blank?
      @full_path = get_full_path([], language)
    end
    @full_path
  end
  
  def get_full_path(s = [], language = 'ru')
    if language == 'ru'
      n = self.name
    else
      n = self.name_en
    end
    res = [[n, "/category/#{self.id}"]] + s
    if !self.category.blank?
      res = self.category.get_full_path(res)
    end
    return res
  end
  

  def self.root_in_menu
    Category.find(:all ,:conditions => ["category_id = 0 AND show_in_menu = 1"], :order => "p")
  end
  
  def all_categories
    all_pages
  end
  
  def page_id
    self.category_id
  end
  xss_terminate :except => [:description]
  
  
  #Проверка, является ли страница с #page_id потомком текущей страницы
  def in_childs(page_id)
    res = false
    for page in self.all_categories
      if page.id == page_id.to_i
        res = true
        break
      else
        if !page.all_categories.blank?
          res =  page.in_childs(page_id)
          if res == true
            break
          end
        end
      end
    end
    return res
  end
  
  belongs_to :category
  has_many :categories, :order => "p", :dependent => :destroy
  has_many :all_pages, :class_name => "Category", :order => "p"
  has_many :categories_in_menu, :class_name => "Category", :conditions => ["show_in_menu = 1"], :order => "p"

  has_and_belongs_to_many :products
  
end
