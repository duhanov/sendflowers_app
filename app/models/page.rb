require 'will_paginate'
require 'russian'

class Page < ActiveRecord::Base


  
  #Проверка, является ли страница с #page_id потомком текущей страницы
  def in_childs(page_id)
    res = false
    for page in self.all_pages
      if page.id == page_id.to_i
        res = true
        break
      else
        if !page.all_pages.blank?
          res =  page.in_childs(page_id)
          if res == true
            break
          end
        end
      end
    end
    return res
  end
  
  def self.createRights
    actions = ["delete", "list", "new", "edit", "destroy"]
    for action in actions
      Right.new({:controller => "admin_pages", :action => action }).save
    end
    actions = ["index"]
    for action in actions
      Right.new({:controller => "p", :action => action }).save
    end
  end
  
  attr :full_path
  
  def full_path
    if @full_path.blank?
      @full_path = get_full_path
    end
    @full_path
  end
  
  def get_full_path(s = [])
#    if self.id > 1
      if (self.title.blank?) || (self.title == "")
        res = [[self.name, "/p/" + self.url.to_s]] + s
      else
        res = [[self.title, "/p/" + self.url.to_s]] + s
      end
 #   else
   #   res = s
  #  end
    if !self.page.blank?
      res = self.page.get_full_path(res)
    end
    return res
  end

  
  def pageTitle
    if !self.page.blank?
      res = self.title + Option.get("sep") + self.page.pageTitle
    else
      res = self.title + Option.get("sep") + Option.get("site_title")
    end
    return res
  end  
  
  def self.items_page(cond, page, on_page = 25)
    paginate :per_page => on_page, :page => page,
      :conditions => cond,
      :order => 'id DESC'
  end
  
  
  def create_url
    if self.url.to_s.strip == ""
      self.url = "#{self.id}-#{self.name.parameterize}"
    end
  end
  
  def before_save
    if self.title.to_s == ""
      self.title = self.name
    end
  end
  
  
  def after_create
    create_url
    self.save
  end

  def before_update
    create_url
  end
  
  validates_presence_of :name
  
  
  xss_terminate :except => [:body]
  
  belongs_to :page
  has_many :pages, :order => "p", :dependent => :destroy
  has_many :all_pages, :class_name => "Page", :order => "p"
  has_many :menu_pages, :conditions => "show_in_menu = 1", :class_name => "Page", :order => "p"

  has_many :admin_pages, :class_name => "Page", :order => "is_system, p"
end
