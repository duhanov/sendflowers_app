module HolidaysHelper
  
  def holiday_types
    [["Праздники", "prazdniki"], ["Именины", 'imenini']]  
  end
  
  def holiday_type(h)
    holiday_types.find{|i| i[1] == h.t}[0]
  end
  
  def holiday_date(holiday)
    d = Date.strptime("#{holiday.holiday_day}/#{holiday.holiday_month}/#{1990}", "%d/%m/%Y")
    if @language == "en"
      return d.strftime("%d %B")
    else
      return Russian::strftime(d, "%d %B")      
    end
  end
end

