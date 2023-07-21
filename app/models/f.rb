class F < ActiveRecord::Base
  validates_presence_of :name, :value
    

      xss_terminate :except => [:body, :body_en]

  def self.list(name)
    F.find(:all, :conditions => ["name = ?", name], :order => "p")
  end
end
