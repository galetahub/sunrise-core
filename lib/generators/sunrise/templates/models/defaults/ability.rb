class Ability
  include CanCanNamespace::Ability
  
  attr_accessor :context, :user

  def initialize(user, context = nil)
    alias_action :delete, :to => :destroy

    @user = (user || User.new) # guest user (not logged in)
    @context = context
    
    case @user.role_type_id
      when RoleType.default.id then default
      when RoleType.redactor.id then redactor
      when RoleType.moderator.id then moderator
      when RoleType.admin.id then admin
    end
  end
  
  def default
    # TODO
  end
  
  def redactor
    # TODO
  end
  
  def moderator
    # TODO
  end
  
  def admin
    can :manage, :all
    can :manage, :all, :context => :manage
    
    # User cannot destroy self account
    cannot :destroy, User, :id => @user.id, :context => :manage
  end
end
