class PaymentMethod < ActiveRecord::Base
  has_attached_file :image, :styles => {:thumb => "88x31>"},
    :url => "/system/payment_methods_images/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/payment_methods_images/:id/:style/:basename.:extension"
  validates_attachment_size :image, :less_than => 5.megabytes
  
  xss_terminate :except => [:description]
end
