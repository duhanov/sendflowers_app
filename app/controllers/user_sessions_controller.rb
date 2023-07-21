class UserSessionsController < ApplicationController
  layout "main"


  
  def new
   # if !current_user.blank?
      #redirect_to "/admin_orders/list"
    #else
      @page_title = translate "auth_title"
      @user_session = UserSession.new
      if !params[:ajax].blank?
        render :layout => false
      end
    #end
  end


  def create
    @user_session = UserSession.new(params[:user_session])
    cookies[:last_login_email] = params[:user_session][:email]
    if @user_session.save
      flash[:notice] = 'Вы успешно вошли.'
      if current_user.is_admin
        redirect_to "/admin_orders/list"
      else
        redirect_to "/profile"
      end
  #    if @user_session.record.is_parthner
#        redirect_to "/parthners/edit"
   #   end
    #  if(params[:back_url].blank?)
#        redirect_to "/admin_orders/list"
   #   else
  #      redirect_to "/admin_orders/list"#params[:back_url]
 #     end
    else
      render :action => "new"
    end
  end

  def destroy
    @user_session = UserSession.find
    if !@user_session.blank?
      @user_session.destroy
    end 
    flash[:notice] = "Вы вышли из системы."
    redirect_to "/"
  end
end
