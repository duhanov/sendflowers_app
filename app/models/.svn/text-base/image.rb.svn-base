require 'fileutils'

class Image < ActiveRecord::Base
  has_attached_file :image, :styles => {:history => "25x25>", :small_flower => "100x100>", :cart => "104x106>", :full => "590x460>", :big => "228x237>" , :thumb => "170x198>", :admin_thumb => "200x120>"},#, :gallery_big => "280x", :gallery_thumb => "86x57#"},
    :url => "/system/images/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/images/:id/:style/:basename.:extension"
  validates_attachment_size :image, :less_than => 5.megabytes
  
  def self.download(url, owner_type, owner_id)
    img = Image.new
    img.save
    path = "#{RAILS_ROOT}/public/system/images/#{img.id}/original"
    FileUtils.makedirs(path)
    img.image_file_name = Wget.download(url, "#{path}/:file_name")    
    img.image_file_size = File.size("#{path}/#{img.image_file_name}")
    img.image_owner_type = owner_type
    img.image_owner_id = owner_id
    img.save
  end
end
