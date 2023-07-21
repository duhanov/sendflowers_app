
class Order < ActiveRecord::Base
  has_many :order_items, :dependent => :destroy
  has_many :phones, :class_name => "OrderPhone", :dependent => :destroy
  belongs_to :delivery
  belongs_to :payment_method
  
#  validates_presence_of :firstname, :delivery_date, :delivery_time, :telephone
 # validates_presence_of :country, :city, :address, :if => :checked_call_to_known_address?
 
  validates_presence_of :firstname, :telephone
  
  
  
  #Валидация на 2м шаге
  validates_presence_of :sender_firstname, :if => Proc.new { |a| a.step == 2 }
  validates_presence_of :sender_email, :if => Proc.new { |a| a.step == 2 }
  validates_presence_of :sender_telephone, :if => Proc.new { |a| a.step == 2 }
  validates_presence_of :sender_country, :if => Proc.new { |a| a.step == 2 }
 # validates_presence_of :easypay_id, :if => Proc.new { |a| (a.step == 10) && (!a.delivery.blank?) && (a.delivery.name == "Easypay")}
  validates_numericality_of :payment_method_id, :only_integer => true, :greater_than => 0, :if => Proc.new { |a| a.step == 2 }

  def payment_url
    url = "/"
    if self.payment_method.name.gsub(/[^a-zA-Z]+/, "").capitalize =~ /webmoney/i
      url = "/order/webmoney/#{self.id}"
    elsif self.payment_method.name.gsub(/[^a-zA-Z]+/, "").capitalize =~ /easypay/i
      url = "/easypay/index/#{self.id}"          
    elsif (self.payment_method.name.gsub(/[^a-zA-Z]+/, "").capitalize =~ /Webpay/i) || self.payment_method.name.gsub(/[^a-zA-Z]+/, "").capitalize =~ /КРЕДИТНАЯ КАРТА/i
      url = "/order/webpay/#{self.id}"
    elsif (self.payment_method.name.to_s =~ /2checkout/i) || (self.payment_method.name.to_s =~ /paypal/i)# || @order.payment_method.name.gsub(/[^a-zA-Z]+/, "").capitalize =~ /КРЕДИТНАЯ КАРТА/i
      url = "/pay2checkout/index/#{self.id}"
    elsif (self.payment_method.name.to_s =~ /rbkmoney/i)# || @order.payment_method.name.gsub(/[^a-zA-Z]+/, "").capitalize =~ /КРЕДИТНАЯ КАРТА/i
      url = "/pay_rbkmoney/index/#{self.id}"
    else
      url = "/order/complete/#{self.id}"
    end
    url
  end


  def translate(text)
    I18n.t text 
  end
  
  def checked_call_to_known_address?
    call_to_known_address == false
  end
  
  def before_save
    if self.total_price_rub.blank? || (self.total_price_rub == 0)
      self.total_price_rub = self.total_price * Option.get("kurs_usd").to_f
    end
    
    if self.delivery_price.blank? && !self.delivery.blank?
      self.delivery_price = self.delivery.price
      self.delivery_price_rub = self.delivery_price.to_f * Option.get("kurs_usd").to_f
    end
  end
  
     #Поиск
  def self.search_page(page , q='', order = 'id DESC')
    paginate :per_page => 50, :page => page,
 #     :conditions => cond,
      :conditions =>["(name LIKE ?) OR (zip LIKE ?) OR (city LIKE ?) OR (address LIKE ?) OR (telephone LIKE ?) OR (email LIKE ?)", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%"],
      :order => order
  end
  
  def set_defaults
    if self.patronymic.to_s == ""
      self.patronymic = translate("patronymic")
    end
    if self.lastname.to_s == ""
      self.lastname = translate("lastname")
    end   
    if self.firstname.to_s == ""
      self.firstname = translate("firstname")
    end
    if self.sender_patronymic.to_s == ""
      self.sender_patronymic = translate("patronymic")
    end
    if self.sender_lastname.to_s == ""
      self.sender_lastname = translate("lastname")
    end   
    if self.sender_firstname.to_s == ""
      self.sender_firstname = translate("firstname")
    end
    self
  end
  
  def before_validation
    if self.patronymic == translate("patronymic")
      self.patronymic = ""
    end
    self.patronymic == translate("patronymic")
    if self.lastname == translate("lastname")
      self.lastname = ""
    end   
    if self.firstname == translate("firstname")
      self.firstname = ""
    end
    if self.sender_patronymic == translate("patronymic")
      self.sender_patronymic = ""
    end
    if self.sender_lastname == translate("lastname")
      self.sender_lastname = ""
    end   
    if self.sender_firstname == translate("firstname")
      self.sender_firstname = ""
    end
  end
  
  def before_create
#    self.status_new_at = DateTime.now
  end
  
  def self.count_new
    Order.count(:conditions => ["status = ?", "new"])
  end

  #Постраничная навигация
  def self.items_page(page , cond = '', per_page = 50, order = 'id DESC')
    paginate :per_page => per_page, :page => page,
      :conditions => cond,
      :order => order
  end
  

end
