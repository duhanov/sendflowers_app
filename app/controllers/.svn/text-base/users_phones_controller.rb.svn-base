class UsersPhonesController < ApplicationController
  def delete_phone
    render :update do |page|
      phone = UserPhone.find_by_id(params[:id])
      if (!phone.blank?) && (phone.user_id == current_user.id)
        page << "$('#phone_#{phone.id}').remove();"
        phone.destroy
      end
    end
  end
  
  def add_phone
    @user = User.find_by_id(current_user.id) 
    phone = UserPhone.new({:country_code => "+375", :city_code => "29", :telephone => "", :user_id => @user.id})
    phone.save
    @user.telephones << phone
    @user.save
    render :partial => "users/phones"
  end

end
