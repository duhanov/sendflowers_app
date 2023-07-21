class Bouquet < ActiveRecord::Base
  
  has_many :bouquet_items, :dependent => :destroy
  
  def is_service
    false
  end
  
  def image
    nil
  end
  
  def description
    ""
  end
end
