class UserSession < Authlogic::Session::Base
  #validates_captcha
  login_field :email
  find_by_login_method :find_by_email
end