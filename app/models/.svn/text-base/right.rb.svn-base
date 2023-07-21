class Right < ActiveRecord::Base
  has_and_belongs_to_many :roles
  
  def self.createRights
    for action in ["delete_role_right", "create_role_right", "new_right", "delete", "admin_rights", "edit", "new", "list", "roles"]
      Right.new({:controller => "admin_rights", :action => action }).save
    end
  end
  
  def has_right_for?(action_name, controller_name)
    action == action_name && controller == controller_name
  end
  
  def self.addController(controller, actions)
    for action in actions
      Right.new({:controller => controller, :action => action}).save    
    end
  end
end
