include Russian

class String
  def parameterize 
    Russian.transliterate(self).downcase.gsub(/[^a-z0-9\-_]+/i, '-')
  end
end

class Option < ActiveRecord::Base
  xss_terminate :except => [:value]

  has_attached_file :file,
    :url => "/system/options/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/options/:id/:style/:basename.:extension"
  validates_attachment_size :file, :less_than => 15.megabytes

  def self.delivery_times
    Option.get('delivery_times').split("\n")#.map{|i| i.to_s.sub("\n","").gsub("\r").to_s.strip}.find_all{|i| i != ""}
  end
  
  def self.delivery_times_en
    Option.get('delivery_times_en').split("\n")#.map{|i| i.to_s.sub("\n","").gsub("\r").to_s.strip}.find_all{|i| i != ""}
  end

  
  def self.createRights
    actions = ["list"]
    for action in actions
      Right.new({:controller => "admin_options", :action => action }).save
    end
  end
    
  def self.clearOptions
    @options = {}  
  end
  
  def self.getOption(name)
    if @options.blank?
      @options = {}
    end
    if @options[name]
      return @options[name]# + "(cached)"
    else
      o = Option.find(:first, :conditions => ["name = ?", name])
      if o.blank?
        @options[name] = ""
      else
        @options[name] = o.value
      end
      return @options[name]
    end
  end
  
  def self.get(name)
    return Option.getOption(name)
  end  
  
  xss_terminate :except => [:title]
  
end
