class ApplicationController < ActionController::Base
  include AuthlogicLogic
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password

  rescue_from 'Acl9::AccessDenied', :with => :access_denied


end
