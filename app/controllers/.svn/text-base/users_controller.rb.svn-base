class UsersController < ApplicationController
  layout "main"

  auto_complete_for :user, :city
  

  
  
  def auto_complete_for_user_city
    method = 'city'
    @items = User.find(:all, :conditions => [ "LOWER(#{method}) LIKE ?", '%' + params[:user][method].downcase + '%' ], :order => "#{method} ASC", :limit => 10)
    render :inline => "<%= auto_complete_result @items, '#{method}' %>"
  end
    
  def enter
    @page_title = "Вход"
    @user_session = UserSession.new
    @user = User.new 
    @is_enter = true
  end

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
  

  def show
    @user = User.find(params[:id])
  end

  def new
    @page_title = translate "users_register_title"
    @user = User.new
    if !params[:ajax].blank?
      render :layout => false
    end
#    puts params.inspect
  end

  # GET /users/1/edit
  def edit
    @page_title = translate "profile_addresses_title"
    @user = User.find_by_id(current_user.id)
  end



  
  
  def create
    #params[:user][:password_confirmation] = params[:user][:password]
    @user = User.new(params[:user])
    @user.roles << Role.find_by_name('Покупатель')
    if @user.save#_with_captcha
      flash[:notice] = translate "users_register_complete"
      #Сохраняем сессю (входим на сайт)
      @user_session = UserSession.new(params[:user])
      @user_session.save
      #Высылаем письмо об успешной регистрации
      begin
      UserMailer.deliver_user_reg(@user, params[:user][:password], @language)
      rescue Exception => exc
        flash[:notice] << exc.message
      end
      #Создаем посты из кинотопа
      if(params[:back_url].blank?)
        redirect_to "/"
      else
        redirect_to params[:back_url]          
      end
    else
     # if simple_captcha_valid?
        
    #  end
      @user.check_errors
      if params[:ajax].blank?
        render :action => "new"
      else
        render :action => "new", :layout => false
      end
    end
  end


  def update_phones
    if !params[:phones].blank?
      for phone_id in params[:phones].keys
        phone = UserPhone.find_by_id(phone_id)
        if (!phone.blank?) && (phone.user_id == current_user.id)
          phone.update_attributes(params[:phones][phone_id])
        end
      end
    end
  end

  def update
    @user = User.find_by_id(current_user.id)

    if @user.update_attributes(params["user"])
      if !params[:ajax].blank?
        xml = Builder::XmlMarkup.new(:indent => 1)
        respond_to do |format|
          format.xml {render :xml => xml.data{
            xml.big(@user.avatar.url(:big))
          }}
        end 
      else
        update_phones
        flash[:notice] = translate "users_edit_complete"
        redirect_to edit_user_path(:current)    
      end
    else
      render :action => "edit"
    end
  end



end
