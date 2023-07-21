class GreetingText < ActiveRecord::Base
	validates_presence_of :body

  #Постраничная навигация
  def self.items_page(page , cond = '', per_page = 50, order = 'id DESC')
    paginate :per_page => per_page, :page => page,
      :conditions => cond,
      :order => order
  end  

  belongs_to :greeting_text_category

  xss_terminate :except => [:body]

  def body_show
  	self.body.to_s.gsub("\n", "<br/>")
  end

end
