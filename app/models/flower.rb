class Flower < ActiveRecord::Base
  belongs_to :flower_name

  has_many :images, :as => :image_owner, :order => :p, :dependent => :destroy  
  def image
      img = Image.find(:first, :conditions => ["image_owner_id = ? AND image_owner_type = ?", self.id, self.type.to_s], :order => "p")
      if !img.blank?
        return img.image
      end
  end
end
