class UsersAddressesController < ApplicationController
  layout "main"
  
  def update
    @user = User.find_by_id(current_user.id)
    if @user.blank?
      redirect_to "/"
    else
      if @user.addresses.blank?
        @address = UserAddress.new({:user_id => @user.id})
        @address.save
        @user.addresses << @address
        @user.save
      end
      @address = @user.addresses.first
      if request.post?
        @address.update_attributes(params[:address])
        flash[:notice] = "Адрес отредактирован"
        redirect_to "/users_addresses"
      end
    end   
  end
  
  def delete
    @address = UserAddress.find_by_id(params[:id])
    if !@address.blank? && !current_user.blank? && current_user.id == @address.user_id
      @address.destroy
      render :update do |page|
        page << "$('#user_address_#{@address.id}').remove();"
      end      
    else
      render :text => ""
    end
  end
  
  def update_address_field
    @address = UserAddress.find_by_id(params[:id])
    if !@address.blank? && !current_user.blank? && current_user.id == @address.user_id
      if params[:field]!= "user_id"
        @address.update_attributes({params[:field] => params[:value] })
      end
    end
    render :text => ""  
  end
  
  def add
    @user = User.find_by_id(current_user.id)
    if @user.blank?
      render :text => ""
    else
      @address = UserAddress.new({:user_id => @user.id})
      @address.save
      @user.addresses << @address
      @user.save
      render :update do |page|
        page.insert_html :bottom, 'user_addresses', render(:partial => "address.#{@language}", :locals => {:address => @address})
      end      
    end
  end
  
  def set_main
    @address = UserAddress.find_by_id(params[:id])
    if !@address.blank? && !current_user.blank? && current_user.id == @address.user_id
      @user = User.find_by_id(current_user.id)
      if !@user.blank?
        for address in @user.addresses
          address.is_main = false
          address.save
        end
        @address.is_main = true
        @address.save
      end
    end
    render :text => ""
  end
  
  def index
    @page_title = translate("profile_addresses_title")
    @user = User.find_by_id(current_user.id)
    if @user.blank?
      redirect_to "/"
    else
      if @user.addresses.blank?
        @address = UserAddress.new({:user_id => @user.id})
        @address.save
        @user.addresses << @address
#        @user.save
      end
      @address = @user.addresses.first
    end
  end
end
