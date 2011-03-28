class Manage::BaseController < ApplicationController
  before_filter :authenticate_user!
  check_authorization
  
  layout "manage"
  respond_to :html
  
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
    
    def current_ability
      @current_ability ||= ::Ability.new(current_user, :manage)
    end
end
