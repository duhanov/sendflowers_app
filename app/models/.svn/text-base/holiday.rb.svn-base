require 'will_paginate'
require 'russian'

class Holiday < ActiveRecord::Base
  xss_terminate :except => [:body1, :body2]

  has_and_belongs_to_many :products

  validates_presence_of :name, :holiday_day, :holiday_month, :body1

  #Постраничная навигация
  def self.items_page(page , cond = '', per_page = 50, order = 'id DESC')
    paginate :per_page => per_page, :page => page,
      :conditions => cond,
      :order => order
  end  
  
  def self.nearest_holidays(limit, language = "ru")
    Holiday.find(:all, :conditions => ["CAST(CONCAT(?,'-',holiday_month,'-',holiday_day) AS DATE) >= ? AND CAST(CONCAT(?,'-',holiday_month,'-',holiday_day) AS DATE) <= ? AND language = ?", DateTime.now.year, DateTime.now, DateTime.now.year, DateTime.now + 20.days, language], :limit => limit)    
  end
end
