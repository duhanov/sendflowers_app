class DeliveryPhoto < ActiveRecord::Base
  has_attached_file :image, :styles => {:thumb => "169x167>", :mini =>"65x62>", :full => "590x460>", :admin_thumb => "200x120>"},#, :gallery_big => "280x", :gallery_thumb => "86x57#"},
    :url => "/system/delivery_photos/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/delivery_photos/:id/:style/:basename.:extension"
  validates_attachment_size :image, :less_than => 5.megabytes
  
  belongs_to :product
  
  #Постраничная навигация
  def self.items_page(page , cond = '', per_page = 50, order = 'created_at DESC')
    paginate :per_page => per_page, :page => page,
      :conditions => cond,
      :order => order
  end
  
end
