class OptionCategory < ActiveRecord::Base
  has_many :options, :order => "options.group, options.p", :conditions => ["h = 0"]
  
  def self.getCategory(name)
    c = OptionCategory.find_by_name(name)
    if c.blank?
      c = OptionCategory.new({:name => name})
      c.save
    end
    return c
  end
end