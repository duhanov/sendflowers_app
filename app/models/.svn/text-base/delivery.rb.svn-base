class Delivery < ActiveRecord::Base
	def is_main_delivery
		if t == 1#Если город основной страны
			return true
		else
			main_delivery = Delivery.find(:first, :order => "p", :conditions => "t=0")
			if main_delivery.blank?
				return false
			else
				if id == main_delivery.id
					return true
				else
					return false
				end
			end
		end
	end
end
