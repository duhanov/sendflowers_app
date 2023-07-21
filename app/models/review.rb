class Review < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :body
  
  def self.count_new
    Review.count(:conditions => ["moderated = ?", false])
  end

  #Постраничная навигация
  def self.items_page(page , cond = '', per_page = 50, order = 'id DESC')
    paginate :per_page => per_page, :page => page,
      :conditions => cond,
      :order => order
  end  
end
