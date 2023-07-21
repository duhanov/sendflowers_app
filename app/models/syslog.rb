class Syslog < ActiveRecord::Base
  
  xss_terminate :except => [:title, :body]
  
  def self.items_page(page, cond = "", on_page = 100)
    paginate :per_page => on_page, :page => page,
      :conditions => cond,
      :order => 'created DESC, id DESC'
  end
  
  def before_create
    self.created = DateTime.now
  end
  
  def self.add_error(from = "", title = "", body = "")
    Syslog.new({:t => from, :title => "<font color='red'>#{title}</font>", :body => body}).save    
  end
  
  def self.add(from = "", title = "", body = "")
    Syslog.new({:t => from, :title => title, :body => body}).save
  end
end
