class Product < ActiveRecord::Base
  xss_terminate :except => [:body, :body_en, :description, :description_en]

  has_and_belongs_to_many :fs



  before_save :set_titles
  def set_titles
    self.title = self.name if self.title.blank?
    self.title_en = self.name_en if self.title_en.blank?
  end


  def price_rub
    (((self.price.to_f * Option.get("kurs_usd").to_f / 100).to_f.ceil)*100).to_i
  end

  #п~_п╬я~Aя~Bя~@п╟пҐп╦я~GпҐп╟я~O пҐп╟п╡п╦пЁп╟я~Fп╦я~O
  def self.items_page(page , cond = '', per_page = 50, order = 'id DESC')
    if cond == ""
      cond = "is_service = 0"
    end
    paginate :per_page => per_page, :page => page,
      :conditions => cond,
      :order => order
  end

  def self.search_page(page, q, per_page, order)
    cond = ["(active = 1) AND (is_service = 0) AND ((name LIKE ?) OR (name_en LIKE ?) OR (meta_keywords LIKE ?) OR (meta_keywords_en LIKE ?))", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%"]
    return paginate :per_page => per_page, :page => page,
      :conditions => cond,
      :order => order
  end
  
  def self.filter_page(page, filter_ids, price=nil, currency="usd", per_page = 50, order = 'id DESC')
    if price.blank?
      cond = "is_service = 0"
    else
      if !currency.blank? && currency=="rub"
        price = price.to_f / Option.get("kurs_usd").to_f      
      end
      cond = ["(is_service = 0) AND (price <= ?) AND (price > 0)", price]
    end

    if filter_ids.blank?
      return paginate :per_page => per_page, :page => page,
        :conditions => cond,
        :order => order
    else

      return paginate :per_page => per_page, :page => page,
        :conditions => cond,
        :joins => "INNER JOIN fs_products ON (fs_products.f_id IN (#{filter_ids.join(',')})) AND (fs_products.product_id=products.id)",
        :order => order
    end
  end
  
  def self.category_page(page , cond='is_service = 0', category_id = '', per_page = 50, order = 'id DESC')
    if category_id == ''
      return paginate :per_page => per_page, :page => page,
        :conditions => cond,
        :order => order
    else
      return paginate :per_page => per_page, :page => page,
        :conditions => cond,
        :joins => "INNER JOIN categories_products ON (categories_products.category_id=#{category_id}) AND (categories_products.product_id=products.id)",
        :order => order
    end
  end

  has_many :images, :as => :image_owner, :order => :p, :dependent => :destroy
  def image
      img = Image.find(:first, :conditions => ["image_owner_id = ? AND image_owner_type = ?", self.id, self.type.to_s], :order => "p")
      if !img.blank?
        return img.image
      end
  end

  #has_and_belongs_to_many :categories, :class_name => "Category"
  has_and_belongs_to_many :categories
end
