require 'digest/md5'
require 'will_paginate'
require 'authlogic'
class User < ActiveRecord::Base
  
#  accepts_nested_attributes_for :company, :allow_destroy => true#, :reject_if => :all_blank
  has_many :telephones, :class_name => "UserPhone", :dependent => :destroy
  has_many :addresses, :class_name => "UserAddress", :dependent => :destroy
  
  def is_admin
    (!self.roles.blank?) && (self.roles[0].name=="Администратор")
  end
  
  def self.createRights
    actions = ["delete", "list", "new", "edit"]
    for action in actions
      Right.new({:controller => "admin_users", :action => action }).save
    end
    actions = ["new", "create", "edit", "update"]
    for action in actions
      Right.new({:controller => "password_resets", :action => action }).save
    end
    actions = ["new", "create", "destroy"]
    for action in actions
      Right.new({:controller => "user_sessions", :action => action }).save
    end
    actions = ["new", "create", "edit", "update"]
    for action in actions
      Right.new({:controller => "users", :action => action }).save
    end
  end
  
  #validates_presence_of :firstname, :lastname, :city, :zip, :address
  apply_simple_captcha :message => "Внимательно вводите символы изображенные на рисунке."
  
 # before_save :check_captcha
  #
  #validate :generic_error

  has_and_belongs_to_many :roles

  #Проверка прав пользователя
  def has_right_for?(action_name, controller_name)
    roles.detect{ |role| role.has_right_for?(action_name, controller_name) }
  end
  
  #Убираем ошибки с password confirmation
  def check_errors
    self.password_confirmation = "123"
    errs = []
    self.errors.each do |attr,message|
      #if (attr == 'password_confirmation') || (message == 'не совпадает с подтверждением')
      #else
      #  errs << {:attr => attr, :message => message}
      #end
      errs << {:attr => attr.gsub("Company title", "Название компании"), :message => message + "!"}
    end
    self.errors.clear
    for e in errs
      self.errors.add(e[:attr], e[:message].to_s)
    end    
  end

  def check_captcha
    if !self.valid_with_captcha?  
      return false
    else
      return true
    end
  end
  
  acts_as_authentic do |c|
#    c.merge_validates_confirmation_of_password_field_options({:if => false})
 #   c.require_password_confirmation = false  
    c.validate_login_field false
  end
 # require_password_confirmation false


  #Постраничная навигация
  def self.items_page(page , cond = '', per_page = 50, order = 'id DESC')
    paginate :per_page => per_page, :page => page,
      :conditions => cond,
      :order => order
  end
  
  
  def self.countNoactive
    return User.count(:conditions => ["active = 0"]) 
  end
  
  
  def deliver_password_reset_instructions!(language)
#    reset_perishable_token!
#    reset_remember_token!
    reset_perishable_token!

    Mailer.deliver_password_reset_instructions(self, language)
  end


  
end
