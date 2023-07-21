class FormTemplate < ActiveRecord::Base

  	validates_uniqueness_of :name, :scope => :language
  	validates_presence_of :name

    xss_terminate :except => [:body]

end
