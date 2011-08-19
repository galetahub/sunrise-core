class Manage::BaseController < ApplicationController
  include Sunrise::Controllers::Manage
  
  protected
  
    rescue_from CanCan::AccessDenied do |exception|
      flash[:failure] = exception.message
      flash[:failure] ||= I18n.t(:access_denied, :scope => [:flash, :users])
            
      respond_to do |format|
        format.html { redirect_to new_session_path(:user) }
        format.xml  { head :unauthorized }
        format.js   { head :unauthorized }
      end
    end
end
