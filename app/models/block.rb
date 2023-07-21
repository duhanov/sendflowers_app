require "paperclip"

class Block < ActiveRecord::Base
  def self.createRights
    actions = ["menu_items_sort", "add2menu", "edit_menu", "update_block", "edit_banner", "edit_text", "remove", "add_block", "update_positions", "list", "edit"]
    for action in actions
      Right.new({:controller => "admin_blocks", :action => action }).save
    end
  end
  
  xss_terminate :except => [:body]


  has_attached_file :image,
    :url => "/resources/blocks/:id/:basename_:style.:extension",
    :path => ":rails_root/public/resources/blocks/:id/:basename_:style.:extension"

  validates_attachment_size :image, :less_than => 5.megabytes


  def self.get(name)
    o = Block.find(:first, :conditions => ["name = ?", name])
    if o.blank?
      return ""
    else
      return o.body
    end
  end
  
  def self.list(t = 0)
    return Block.find(:all, :conditions => ["t = ?", t], :order => "p")    
  end

end
