include Russian

class News < ActiveRecord::Base

  xss_terminate :except => [:body]
   
  has_attached_file :image, :styles => {:thumb => "215x140#", :thumb2 => "170x115#" },
  :convert_options => { :thumb => '-gravity northwest' },
#  :convert_options => { :thumb => '-background white -gravity center -extent 50x50' },
  :url => "/resources/news_images/:id/:style/:basename.:extension",
  :path => ":rails_root/public/resources/news_images/:id/:style/:basename.:extension"
  validates_attachment_size :image, :less_than => 5.megabytes

  #has_attached_file :avatar, :styles => { :small => "100x100#", :large => "500x500>" }, :processors => [:cropper]
  #attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  #after_update :reprocess_avatar, :if => :cropping?
  
#  def cropping?
 ##   !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  #end
  
  #def avatar_geometry(style = :original)
   # @geometry ||= {}
    #@geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
  #end
  
  validates_presence_of :title
  
  def self.items_page(page, cond = "", on_page = 25, order = "created_at DESC")
    paginate :per_page => on_page, :page => page,
      :conditions => cond,
      :order => order
  end
  
  def after_create
    self.url = "#{self.id}-#{self.title.parameterize}"
    self.save
  end
  
  def before_update
    self.url = "#{self.id}-#{self.title.parameterize}"
  end
  

end
