class HolidaysController < ApplicationController
  layout "main"
  
  def index
    @months = []
    @months_nominative = []
    for i in 1..12
      @months << [I18n.t("holiday_month_#{i}"), i]
      @months_nominative << [I18n.t("holiday_month_nominative_#{i}"), i]
      
    end

    @filters = [[translate("holidays_all"), "all"], [translate("holidays_prazdniki"), "prazdniki"], [translate("holidays_imenini"), "imenini"]]
    if params[:filter].blank?
      @filter = @filters[0]
    else
      @filter = @filters.find{|i| i[1] == params[:filter]}
      if @filter.blank?
        @filter = @filters[0]        
      end
    end
    if !params[:id].blank?
      @month_i = params[:id].to_i
    else
      @month_i = DateTime.now.month
    end
    if @month_i < 1 || @month_i > 12
      @month_i = DateTime.now.month      
    end
    
    @month = @months.find{|i| i[1] == @month_i}
    @text = "#{I18n.t('page_title_prazdniki_i_imenini')} #{I18n.t('holiday_in_month').downcase} #{@month[0]}"
    @page_title = @text

    if @filter == @filters[0]
      @holidays = Holiday.find(:all, :conditions => ["holiday_month = ? AND language= ?", @month_i, @language], :order => "holiday_month, holiday_day") 
    else
      @holidays = Holiday.find(:all, :conditions => ["holiday_month = ? AND t = ? AND language = ?", @month_i, @filter[1], @language], :order => "holiday_month, holiday_day")       
    end
  end
  
  def month
    index
    render :action => "index"
  end
  
end
