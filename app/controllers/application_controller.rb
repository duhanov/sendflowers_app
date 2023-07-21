require 'geoip'

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
include TranslateHelper

class ApplicationController < ActionController::Base
  session :session_key => '_www.flowerminsk.by_session'
  
  
  helper :all # include all helpers, all the time
 # protect_from_forgery :secret => '7e9f911392a473d4ee3d2f072cab002b'# See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password, :password_confirmation
#  before_filter :ssl_redirect
  before_filter :check_authorization#, :except => [:signin, :signout, :register, :denied, :login, :enter]
  before_filter :init_cart
  skip_before_filter :verify_authenticity_token

  before_filter :set_default_content_type
  before_filter :set_language
  before_filter :init_filters
  before_filter :set_currency_from_ip

  def init_filters
    @filters_titles = []
    @filters_titles << {:title => "Повод", :name => "reason"}
    @filters_titles << {:title => "Праздники", :name => "holiday"}
    @filters_titles << {:title => "Кому", :name => "who"}
    @filters_titles << {:title => "Цвет", :name => "color"}
  end

  def ssl_redirect
      if  (request.protocol.to_s.downcase != "https://")
        redirect_to request.url.gsub(/^http\:\/\//i, "https://"), :status => 301
        return false
      else
        return true
      end
  end




  def set_currency_from_ip
    @debug= "Test"
    if session[:currency].blank? && Option.find_by_name('geoip_file').file? 
      @debug="get coutnry from ip #{request.remote_addr}"
      begin
        @geoip ||= GeoIP.new(Option.find_by_name('geoip_file').file.path)
        @country = @geoip.country(request.remote_addr)[4]
        if ["RU", "BY", "BLR", "RUS"].include?(@country)
          session[:currency] = "rub"
        else
          session[:currency] = "usd"          
        end
        rescue Exception => exc
          @debug = "Error: #{exc.message}"
        end
    else
      @debug = "Curencty already set: #{session[:currency]}"
    end
  end
  
  def set_language_old
    if params[:language].blank?
      @language = "ru"
    else
      if ["ru", "en"].include?(params[:language])
        @language = params[:language]
      else
        @language = "ru"
      end
    end
    I18n.locale = @language
  end
  
  def set_language
    if ["www.flower-shop.by", "flower-shop.by"].include?(request.domain.to_s.downcase)
      @language = "en"
    else
      @language = "ru"
    end
    
    #render :text => @language

    I18n.locale = @language
  end

  def set_content_type(content_type)
    response.headers["Content-Type"] = content_type
  end

  def set_default_content_type
    set_content_type("text/html; charset=utf-8")
  end
  

  def find_cart
    if session[:cart].blank?
      #puts "create cart!"
      session[:cart] = Cart.new
    end
    session[:cart]
  end
  
  def init_cart
    @cart = find_cart
    return true
  end
  
  #def find_cart
  #  session[:cart] ||= Cart.new
  #end  
  
  def domain
    res = request.host.downcase.gsub(/^(www\.)/, "")
    if request.port != 80
      res = "#{res}:#{request.port}"
    end
    res
  end

  def check_authorization
#    self.allow_forgery_protection = false
    Russian::init_i18n
    if params[:controller] =~ /^admin\_.+$/
      if (!current_user.blank?) && (!current_user.roles.blank?) &&(current_user.roles[0].name=="Администратор")
        return true
      else
        flash[:error] = "Доступ запрещен."
        redirect_to "/login"
        return false
      end
    elsif ["users_addresses","users", "users_phones", "orders"].include?(params[:controller])
      if (!current_user.blank?) && (["Покупатель", "Администратор"].include?(current_user.roles[0].name))
        return true
      else
        return false
      end
    else
      return true
    end
  end
  
    def check_authorization_old
    if self.class.controller_path == "admin_main"
      return true
    else
      @is_guest = true
      if current_user.blank?
        role = Role.find(:first, :conditions => ['id = ?', 1])
        @role = role
        unless role.rights.detect{|right|
            right.action == action_name && right.controller == self.class.controller_path
          
          }
          flash[:error] = "Доступ запрещен."
          redirect_to "/login"
          return false
        end
      else
        @role = current_user.roles[0]
        role = @role
        @is_guest = false
        #����� ������� ����� ������������
        unless current_user.roles.detect{|role|
          role.rights.detect{|right|
            right.action == action_name && right.controller == self.class.controller_path
            }
          }
          flash[:error] = "������ �������. ���������� ���������������."
          redirect_to "/login"
          return false
        end
      end
    end
  end  

  helper_method :current_user


  def redirect_tab(url)
    if !params[:tab_selected].blank?
      redirect_to "#{url}?tab_selected=#{params[:tab_selected]}"
    else
      redirect_to "#{url}"      
    end
  end
  
  private
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "�� ������ ����� ����� ���������� ���� ��������."
      redirect_to "/"#account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end
end
