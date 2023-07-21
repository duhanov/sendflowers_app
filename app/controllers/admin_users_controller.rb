class AdminUsersController < ApplicationController
  
  
  layout "admin"
  require "fileutils"
  require "md5"
  require 'mysql'


  before_filter :init_tabs
  
  def model_title
    {:what => "пользователя", :list => "пользователей"}  
  end

  def init_tabs
    @tabs = [["Добавить #{model_title[:what]}", "/#{params[:controller]}/new"], ["Список #{model_title[:list]}", "/#{params[:controller]}/list/"]]  
    if params[:action] == "edit"
      @tabs = [["Редактировать #{model_title[:what]}", "/#{params[:controller]}/edit/#{params[:id]}"]] + @tabs
    end
  end
  
  #Удаление нескольких пользователей
  def delete
    
    item = User.find(:first, :conditions => ["id = ?", params[:id]]) 
    if !item.blank?
      item.destroy
      #flash[:notice] = "Запись удалена"
    end
    render :text => "deleted"   
  end
  
  #Список пользователей
  def list
    
    @sort = "id DESC"
    if !params[:sort].blank?
      if ["id", "id DESC", "Email", "Email DESC", "t", "t DESC"].include?(params[:sort])
        @sort = params[:sort]
      end
    end
    
    @users = User.items_page(params[:page], '', 50, @sort)
    @page_title = "Список пользователей"
    @add_or_edit_btn_title = "Добавить"
    @add_or_edit_btn = "new"
    @active_btn = "list"
  end



 

  def new
    @page_title = "Создание пользователя"
    @add_or_edit_btn_title = "Добавить"
    @add_or_edit_btn = "new"
    @active_btn = "new"
    #Получаем список ролей
#    if session[:user].t == 8
      @roles = Role.find(:all)
 #   else
  #    r1 = Role.new
   #   r1.id = 9
    #  r1.name = "Покупатель"
     # r2 = Role.new
   #   r2.id = 10
   #   r2.name = "Продавец"
   #   @roles = Array.new
   #   @roles << r1
   #   @roles << r2
   # end
    
    @user = User.new
    @user.roles = [Role.find(:first)]
    #Если отправили форму
    if request.post?
      params[:user][:password_confirmation] = params[:user][:password]
      @user = User.new(params[:user])

      @user.roles = [Role.find_by_id(params[:role])]
      if @user.save
        #Создаем роль
        flash[:notice] = 'Пользователь добавлен.'
        redirect_to "/admin_users/list"
      else
        @user.check_errors

      end
    end
  end

  # GET /users/1/edit
  def edit
    @page_title = "Редактирование пользователя"
    @add_or_edit_btn_title = "Редактировать"
    @add_or_edit_btn = "edit"
    @active_btn = "new"
    #Получаем список ролей
    #if session[:user].t == 8
      @roles = Role.find(:all)
    #else
    #  r1 = Role.new
    #  r1.id = 9
    #  r1.name = "Покупатель"
    #  r2 = Role.new
    #  r2.id = 10
    #  r2.name = "Продавец"
    #  @roles = Array.new
    #  @roles << r1
    #  @roles << r2
    #end
    if request.post?
      params[:user][:password_confirmation] = params[:user][:password]
      @user = User.find_by_id(params[:id])#(:first, :conditions => ['id = ?', params[:user][:id]])
      old_active = @user.active
      params[:user][:email] = @user.email
      #if (session[:user].t != 8) && ((![9, 10].include?(@user.t)) || (![9, 10].include?(params[:role].to_i))) 
      #  redirect_to "/admin/users/makers"
      #else
      #  params[:user][:t] = params[:role]
        #old_active = @user.active
        if @user.update_attributes(params[:user])
          if old_active != @user.active
            if !@user.company.blank?
              @user.company.active = @user.active
              Product.update_all(["active = ?", @user.active], ["company_id = ?", @user.company.id])
            end
          end
        #  if (old_active == 0) && (@user.active == 1)
        #    Mailer.deliver_user_activated(@user)
        #  end
          @user.roles = [Role.find_by_id(params[:role])]
          @user.save
          
          flash[:notice] = 'Пользователь отредактирован.'
      #    redirect_to "/admin_users/edit/" + params[:user][:id].to_s
       
          redirect_to "/admin_users/edit/#{params[:id]}"

 end
      #end
    else  
      @user = User.find(params[:id])    
    end
  end


end
