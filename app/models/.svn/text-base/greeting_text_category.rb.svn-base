class GreetingTextCategory < ActiveRecord::Base
	validates_presence_of :name
	has_many :greeting_texts, :dependent => :destroy
end
